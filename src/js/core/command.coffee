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
			options.tries--
			
			# Resend request after 1sec
			window.setTimeout ->
				send(options)
				return
			, 1000
			
		else
			# Call fail callback
			if options.fail? then options.fail(status)

		return

	success = (data, status, jqXHR) ->
		# Call success callback
		if options.success?
			options.success(data)

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
