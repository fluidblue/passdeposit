###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

send = (commandObject) ->
	success = (data) ->
		console.log data

	error = (jqXHR, textStatus) ->
		console.log textStatus

	$.ajax
		type: "POST"
		url: "passdeposit"
		data:
			obj: JSON.stringify(commandObject)
		success: success
		dataType: "json"

add = (item) ->
	console.log item

	# Send command
	send
		cmd: "add"
		data: item

modify = (item) ->
	console.log item

remove = (id) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
