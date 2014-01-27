###
# PassDeposit #

Created by Max Geissler
###

https = require "https"
fs = require "fs"
path = require "path"
staticFiles = require "./staticFiles"
dynamic = require "./dynamic"
database = require "./database"
log = require "./log"
config = require "./config"

reResetURL = /\/reset-.+-([a-f]|[0-9])+$/
files = null

# Define HTTPS handler
httpsHandler = (req, res) ->
	# Get client ID
	clientID = req.connection.remoteAddress + ":" + req.connection.remotePort

	# Log
	if config.get().verbose
		log.info clientID + " requests " + req.url

	# Separate URL from query string
	url = req.url.split("?")[0]

	# Check if dynamic content is requested
	if url == "/passdeposit"
		# Get POST data
		postData = ""

		req.on "data", (chunk) ->
			postData += chunk

		req.on "end", ->
			dynamic.serve clientID, postData, (response) ->
				# Send data
				# Response: 200 OK
				res.writeHead 200, response.headers
				res.end response.content
	else
		# Show default page when no query is given.
		# Also show default page for reset links.
		if url == "/" || url == "" || reResetURL.test(url)
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

getHttpsOptions = ->
	options = config.get().https

	loadFile = (propertyFile, property) ->
		if options[propertyFile]?
			try
				options[property] = fs.readFileSync(path.resolve(config.get().basePath, options[propertyFile]))
			catch e
				log.error "Could not load " + options[propertyFile] + " (specified in " + config.get().configFile + ")"
				process.exit 0

			delete options[propertyFile]
			return true

		return false

	# Maintain compatibility with older configs
	loadFile("privateKey", "key")
	loadFile("certificate", "cert")

	# Load certificate files
	loadFile("pfxFile", "pfx")
	loadFile("keyFile", "key")
	loadFile("certFile", "cert")

	return options

init = ->
	# Connect to database
	database.init ->
		# Load static files
		staticFiles.load (staticFiles) ->
			files = staticFiles

			# Create HTTPS server
			try
				server = https.createServer(getHttpsOptions(), httpsHandler)
				server.listen config.get().port
			catch e
				message = e.message
				if message == "mac verify failure"
					message += " (perhaps private key password incorrect)"

				log.error "Could not start https server: " + message

				process.exit 0

module.exports.init = init
