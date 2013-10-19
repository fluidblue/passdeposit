###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

send = (commandObject) ->
	$.post "passdeposit",
		data: JSON.stringify(commandObject)

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
