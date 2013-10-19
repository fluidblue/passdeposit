###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item) ->
	fail = (status) ->
		console.log "Failed to add item (status: " + status + ")"

	success = (response) ->
		console.log response

	# Send command
	command.send
		cmd: "add"
		data: item
		success: success
		fail: fail

modify = (item) ->
	console.log item

remove = (id) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
