###
# PassDeposit #

Created by Max Geissler
###

zlib = require "zlib"
command = require "./command"

serve = (post, callback) ->
	# Get command (and the corresponding data)
	commandObject = {}

	if post.data?
		commandObject = JSON.parse(post.data)

	# Process command
	result = command.process(commandObject.cmd, commandObject.data)
	content = JSON.stringify(result)

	# gzip content
	zlib.gzip content, (_, result) ->
		# Define response
		response =
			# gzipped content
			content: result
			
			# HTTP Headers
			headers:
				"Content-Type": "text/javascript; charset=utf-8"
				"Content-Encoding": "gzip"
				"Content-Length": result.length
				"Vary": "Accept-Encoding"

				# Prevent caching
				"Cache-Control": "no-store, no-cache, must-revalidate, post-check=0, pre-check=0"
				"Pragma": "no-cache"
				"Expires": "0"

		# Return via callback
		callback(response)

module.exports.serve = serve
