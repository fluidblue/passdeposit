###
# PassDeposit #
Server communication

Created by Max Geissler
###

send = (commandObject, success, fail, tries = 3) ->
	complete = (jqXHR, status) ->
		# Check for error
		if status == "success" || status == "notmodified"
			# Call success callback
			if success? then success()
		else
			if tries > 1
				# Resend request after 1sec
				window.setTimeout ->
					send(commandObject, success, fail, tries - 1)
					return
				, 1000
				
			else
				# Call fail callback
				if fail? then fail(status)

		return

	$.ajax
		type: "POST"
		url: "passdeposit"
		data:
			obj: JSON.stringify(commandObject)
		complete: complete
		dataType: "json"

module.exports.send = send
