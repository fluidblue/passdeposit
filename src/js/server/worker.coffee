###
# PassDeposit #

Created by Max Geissler
###

https = require "https"
http = require "http"
fs = require "fs"
path = require "path"
staticFiles = require "./staticFiles"
dynamic = require "./dynamic"
database = require "./database"
log = require "./log"
config = require "./config"

reResetURL = /\/reset-.+-([a-f]|[0-9])+$/
files = null

# HTTP/HTTPS server
server = null

# Worker state
terminating = false

# Time (ms) to wait before killing worker
killWait = 2000

# Define HTTP/HTTPS handler
requestHandler = (req, res) ->
	if terminating
		# HTTP Headers
		headers =
			"Connection": "close"
			"Retry-After": Math.ceil(killWait / 1000) + 2
			"Content-Length": 0

		# Send 503 Service Unavailable
		res.writeHead 503, headers
		res.end()

		return
	
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
	if !options.enabled
		return options

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

terminate = ->
	if terminating
		return

	terminating = true
	if config.get().verbose
		log.info "Shutting down worker..."

	if server != null
		# Do not accept new connections.
		server.close ->
			# Exit when all connections are closed.
			process.exit 0

		# Wait short time before killing the worker.
		# This will allow ongoing requests to be finished.
		setTimeout ->
			process.exit 0
		, killWait
	else
		process.exit 0

init = ->
	# Set termination handlers
	process.on "SIGINT", terminate
	process.on "SIGTERM", terminate

	# Connect to database
	database.init ->
		# Load static files
		staticFiles.load (staticFiles) ->
			if terminating
				return

			files = staticFiles

			# Create HTTPS server
			try
				httpsOptions = getHttpsOptions()
				if !httpsOptions.enabled
					server = http.createServer(requestHandler)
				else
					server = https.createServer(httpsOptions, requestHandler)
				server.listen config.get().port
			catch e
				message = e.message
				if message == "mac verify failure"
					message += " (perhaps private key password incorrect)"

				log.error "Could not start webserver: " + message

				process.exit 0

module.exports.init = init
