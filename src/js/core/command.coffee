###
# PassDeposit #
Server communication

Created by Max Geissler
###

config = require "../config"

send = (options) ->
	# Try 3 times
	if !options.tries?
		options.tries = 3

	# Define default handler
	if !options.callback?
		options.callback = (response) ->
			if response.status != "success"
				console.log "Ajax request failed: " + response.status

			return

	complete = (jqXHR, status) ->
		# Cancel if succeeded
		if status == "success" || status == "notmodified"
			return

		# Check retry
		if options.tries > 1
			# Resend request
			options.tries--
			send(options)
		else
			# Failed
			options.callback
				status: "ajax:" + status

		return

	success = (data, status, jqXHR) ->
		# Success
		options.callback(data)
		return

	obj =
		cmd: options.cmd
		data: options.data

	$.ajax
		type: "POST"
		url: "passdeposit"
		data:
			obj: JSON.stringify(obj)
		dataType: "json"
		complete: complete
		success: success

module.exports.send = send
