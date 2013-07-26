###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"

clip = null

init = ->
	ZeroClipboard.setDefaults moviePath: "media/zeroclipboard.swf"
	clip = new ZeroClipboard()

	clip.on "load", (client, args) ->
		# TODO: Remove
		alert "movie has loaded"
		return

setText = (text) ->
	clip.setText text

module.exports.init = init
module.exports.setText = setText
