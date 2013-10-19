###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"

add = (item) ->
	callback = (response) ->
		if response.status != "success"
			# Show error
			errorMsg = $("#text .itemSaveFailed").html()
			errorMsg = errorMsg.replace(/%1/g, response.status)

			$.jGrowl errorMsg

			return

		# TODO
		#response.id

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
