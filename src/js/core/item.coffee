###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item) ->
	callback = (response) ->
		if response.status == "success"
			console.log response
		else
			console.log "Failed to add item (" + response.status + ")"

	# Send command
	command.send
		cmd: "add"
		data: item
		callback: callback

modify = (item) ->
	console.log item

remove = (id) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
