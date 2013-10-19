###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item, callback) ->
	# Send command
	command.send
		cmd: "add"
		data: item
		callback: callback

modify = (item, callback) ->
	console.log item

remove = (id, callback) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
