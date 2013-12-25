###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

#ZeroClipboard = require "zeroclipboard"
global = require "."

clip = null

init = ->
	# TODO

	# ZeroClipboard.setDefaults moviePath: "media/zeroclipboard.swf"
	# clip = new ZeroClipboard()

	# clip.on "load", (client, args) ->
	# 	# TODO: Remove
	# 	console.log "movie has loaded"
	# 	return

setText = (text) ->
	# TODO: Remove
	#console.log("Copy to clipboard: " + text)

	# Set text
	#clip.setText text

	# Show notification
	#global.jGrowl.show global.text.get("copiedToClipboard")
	global.jGrowl.show "Copy-to-clipboard is not yet implemented."

module.exports.init = init
module.exports.setText = setText
