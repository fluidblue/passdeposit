###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

global = require "."

copyText = (input) ->
	# Uses html5 clipboard api

	# Select the text field
	input.select()

	# For mobile devices
	if input.setSelectionRange?
		input.setSelectionRange(0, 99999)

	# Copy the text inside the field
	document.execCommand("copy")

	# Show info
	global.jGrowl.show global.text.get("copiedToClipboard")

module.exports.copyText = copyText
