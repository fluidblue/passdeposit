###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item) ->
	console.log item

	# Send command
	command.send
		cmd: "add"
		data: item
		success: ->
			console.log "success"
		fail: (status) ->
			console.log status

modify = (item) ->
	console.log item

remove = (id) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
