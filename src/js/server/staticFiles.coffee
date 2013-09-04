###
# PassDeposit #

Created by Max Geissler
###

fs = require("fs")
path = require("path")
zlib = require("zlib")
crypto = require("crypto")

httpdocs = path.resolve(path.dirname(require.main.filename), "../httpdocs")

md5 = (data) ->
	return crypto.createHash('md5').update(data).digest("hex")

getContentType = (uri) ->
	ext = path.extname(uri).toLowerCase()

	switch ext
		when ".htm", ".html" then "text/html; charset=utf-8"
		when ".css" then "text/css"
		when ".js" then "application/javascript"
		when ".png" then "image/png"
		when ".gif" then "image/gif"
		when ".ico" then "image/x-icon"
		when ".swf" then "application/x-shockwave-flash"
		else "text/plain"

getFileList = (directory) ->
	files = []

	walkDir = (root, relative) ->
		dir = path.join(root, relative)

		for item in fs.readdirSync(dir)
			fullPath = path.join(dir, item)
			relativePath = path.join(relative, item)

			stats = fs.statSync(fullPath)
			
			if stats.isFile()
				files.push
					uri: "/" + relativePath
					path: fullPath

			else if stats.isDirectory()
				walkDir(root, relativePath)

	# Recursively walk through directory
	walkDir directory, ""

	return files

loadStaticFile = (uri, file, callback) ->
	# Load file content
	content = fs.readFileSync file

	# gzip file content
	zlib.gzip content, (_, result) ->
		tag = md5(result)

		# Define new static file
		staticFile =
			# gzipped content
			content: result
			
			# HTTP Headers (200 OK)
			headers:
				"Content-Type": getContentType(uri)
				"Content-Encoding": "gzip"
				"Content-Length": result.length
				"ETag": tag
				"Vary": "Accept-Encoding"
			
			# HTTP Headers (304 Not Modified)
			headersCached:
				"ETag": tag
				"Vary": "Accept-Encoding"

		# Return via callback
		callback(staticFile)

load = (callback) ->
	fileList = getFileList(httpdocs)
	staticFiles = []

	loadAllFiles = ->
		file = fileList.pop()
		loadStaticFile file.uri, file.path, (staticFile) ->
			# Add to static files
			staticFiles[file.uri] = staticFile

			if fileList.length == 0
				# Finished. Return results.
				callback(staticFiles)
			else
				# Continue with next file
				loadAllFiles()

	# Start loop
	loadAllFiles()

module.exports.load = load
