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
log = require "./log"
config = require "./config"

reResetURL = /\/reset-.+-([a-f]|[0-9])+$/

loadCertificate = ->
	options = {}

	try
		options.key = fs.readFileSync(path.resolve(config.get().basePath, config.get().https.privateKey))
		options.cert = fs.readFileSync(path.resolve(config.get().basePath, config.get().https.certificate))
	catch e
		log.error "Could not load certificate / private key (specified in '" + config.get().configFile + "')"
		process.exit 0

	return options

init = ->
	# Connect to database
	database.init ->
		# Load certificate
		options = loadCertificate()

		# Load static files
		staticFiles.load (files) ->
			
			# Define HTTPS handler
			httpsHandler = (req, res) ->
				# Get client ID
				clientID = req.socket.address().address

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
						postObject = querystring.parse(postData)
						dynamic.serve clientID, postObject, (response) ->
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

			# Create HTTPS server
			server = https.createServer(options, httpsHandler)
			server.listen config.get().port

module.exports.init = init
