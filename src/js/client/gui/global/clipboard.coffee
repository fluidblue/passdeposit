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

module.exports.init = init
module.exports.activate = activate
module.exports.deactivate = deactivate
module.exports.copyText = copyText
