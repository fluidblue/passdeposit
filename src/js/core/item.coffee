###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item, callback) ->
	# Add encryption details
	# TODO: Encrypt
	item.encryption =
		type: "aes256"
		param0: 0
		param1: 1

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
		cmd: "remove"
		data: id
		callback: callback

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
