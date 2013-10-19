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
		# Check for error
		if status == "success" || status == "notmodified"
			# Call success callback
			if options.success? then options.success()
		else
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

	obj =
		cmd: options.cmd
		data: options.data

	$.ajax
		type: "POST"
		url: "passdeposit"
		data:
			obj: JSON.stringify(obj)
		complete: complete
		dataType: "json"

module.exports.send = send
