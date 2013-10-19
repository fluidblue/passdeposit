###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

com = require "./com"

add = (item) ->
	console.log item

	# Send command
	com.send
		cmd: "add"
		data: item
	, ->
		console.log "success"
	, (status) ->
		console.log status

modify = (item) ->
	console.log item

remove = (id) ->
	console.log "Delete item: " + id

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
