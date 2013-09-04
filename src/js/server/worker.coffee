###
# PassDeposit #

Created by Max Geissler
###

https = require("https")
fs = require("fs")
querystring = require("querystring")
staticFiles = require("./staticFiles")

privateKey = "cert/privatekey.pem"
certificate = "cert/certificate.pem"

init = (port) ->
	# Load certificate
	options =
		key: fs.readFileSync(privateKey)
		cert: fs.readFileSync(certificate)

	# Load static files
	staticFiles.load (files) ->

		# Define HTTPS handler
		handler = (req, res) ->
			# TODO: Only in debug
			console.log req.socket.address().address + " requests " + req.url

			# Separate URL from query string
			url = req.url.split("?")[0]

			# Check if dynamic content is requested
			if url == "/passdeposit"
				# TODO: Remove
				postHTML = "<html><head><title>Post Example</title></head>" +
				"<body>" +
				"<form method=\"post\">" +
				"Input 1: <input name=\"input1\"><br>" +
				"Input 2: <input name=\"input2\"><br>" +
				"<input type=\"submit\">" +
				"</form>" +
				"</body></html>"

				# Get POST data
				postData = ""

				req.on "data", (chunk) ->
					postData += chunk

				req.on "end", ->
					postObject = querystring.parse(postData)
					console.log "POSTed: " + postObject.input1
					res.writeHead 200
					res.end postHTML
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
		server = https.createServer(options, handler)
		server.listen port

module.exports.init = init
