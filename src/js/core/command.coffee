###
# PassDeposit #
Server communication

Created by Max Geissler
###

send = (options) ->
	# Try 3 times
	if !options.tries?
		options.tries = 3

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
			# Call fail callback
			if options.callback? then options.callback
				status: "ajax:" + status

		return

	success = (data, status, jqXHR) ->
		# Success
		if options.callback?
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
