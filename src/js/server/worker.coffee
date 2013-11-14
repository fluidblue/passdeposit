###
# PassDeposit #

Created by Max Geissler
###

https = require "https"
fs = require "fs"
querystring = require "querystring"
path = require "path"
staticFiles = require "./staticFiles"
dynamic = require "./dynamic"
database = require "./database"

loadCertificate = (config) ->
	options = {}

	try
		options.key = fs.readFileSync(path.resolve(config.basePath, config.https.privateKey))
		options.cert = fs.readFileSync(path.resolve(config.basePath, config.https.certificate))
	catch e
		console.log "Error: Could not load certificate/privateKey (specified in '" + config.configFile + "')"
		process.exit 0

	return options

init = (config) ->
	# Connect to database
	database.init config, ->
		# Load certificate
		options = loadCertificate(config)

		# Load static files
		staticFiles.load (files) ->
			
			# Define HTTPS handler
			httpsHandler = (req, res) ->
				# TODO: Only in debug
				console.log req.socket.address().address + " requests " + req.url

				# Separate URL from query string
				url = req.url.split("?")[0]

				# Check if dynamic content is requested
				if url == "/passdeposit"
					# Get POST data
					postData = ""

					req.on "data", (chunk) ->
						postData += chunk

					req.on "end", ->
						postObject = querystring.parse(postData)
						dynamic.serve postObject, (response) ->
							# Send data
							# Response: 200 OK
							res.writeHead 200, response.headers
							res.end response.content
				else
					# Set default page
					if url == "/" || url == ""
						url = "/index.htm"

					# Send content
					if files[url]?
						# Serve file
						if req.headers["if-none-match"] == files[url].headers.ETag
							# File is cached in browser
							# Response: 304 Not Modified
							res.writeHead 304, files[url].headersCached
							res.end()
						else
							# Send file
							# Response: 200 OK
							res.writeHead 200, files[url].headers
							res.end files[url].content
					else
						# File doesn't exist
						# Response: 404 Not Found
						res.writeHead 404
						res.end "404 Not Found"

			# Create HTTPS server
			server = https.createServer(options, httpsHandler)
			server.listen config.port

module.exports.init = init
