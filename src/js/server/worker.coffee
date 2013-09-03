###
# PassDeposit #

Created by Max Geissler
###

cluster = require("cluster")
https = require("https")
fs = require("fs")
zlib = require("zlib")
crypto = require("crypto")

privateKey = "/Users/max/Desktop/PassDeposit/cert/privatekey.pem"
certificate = "/Users/max/Desktop/PassDeposit/cert/certificate.pem"

md5 = (data) ->
	return crypto.createHash('md5').update(data).digest("hex")

init = (port) ->
	options =
		key: fs.readFileSync(privateKey)
		cert: fs.readFileSync(certificate)

	handler = (req, res) ->
		if req.headers["if-none-match"] == "92b0a5a28433b3ce3ee6d01a84b4508c"
			console.log "Request: " + req.url + " (304 Not Modified)"
			
			headers =
				"ETag": req.headers["if-none-match"]
				"Vary": "Accept-Encoding"

			# Send 304 Not Modified
			res.writeHead 304, headers

			# Finish
			res.end()
		else
			console.log "Request: " + req.url

			# Get content
			text = "hello world\n"

			# Set encoding to UTF-8
			buf = new Buffer(text, "utf-8")

			# gzip buffer
			zlib.gzip buf, (_, result) ->
				headers =
					"Content-Type": "text/html; charset=utf-8"
					"Content-Encoding": "gzip"
					"Content-Length": result.length
					"ETag": md5(result)
					"Vary": "Accept-Encoding"

				# Send 200 OK
				res.writeHead 200, headers

				# Send gzipped buffer
				res.end result

	# Create HTTPS server
	server = https.createServer(options, handler)
	server.listen port

module.exports.init = init
