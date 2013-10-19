###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item, callback) ->
	# Send command to server
	command.send
		cmd: "add"
		data: item
		callback: callback

modify = (item, callback) ->
	# Send command to server
	command.send
		cmd: "modify"
		data: item
		callback: callback

remove = (id, callback) ->
	# Send command to server
	command.send
		cmd: "delete"
		data: id
		callback: callback

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
