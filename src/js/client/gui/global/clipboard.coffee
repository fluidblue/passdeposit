###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"
jGrowl = require "./jGrowl"
text = require "./text"

# This fixes a bug in ZeroClipboard, where the load event never gets fired.
window.ZeroClipboard = ZeroClipboard

init = ->
	ZeroClipboard.config
		moviePath: "media/zeroclipboard.swf"
		cacheBust: false
		forceHandCursor: true
		debug: true # Verbose mode

	# Testing
	bind $("#loginButton"), (elem) ->
		$(elem).css "color", "red"
		return "Test: " + (new Date()).toString()

setText = (text) ->
	# TODO: Remove
	#console.log("Copy to clipboard: " + text)

	# Set text
	#clip.setText text

	# Show notification
	#jGrowl.show text.get("copiedToClipboard")
	jGrowl.show "Copy-to-clipboard is not yet implemented."

bind = (jqElem, fnText) ->
	if ZeroClipboard
		client = new ZeroClipboard(jqElem)

		client.on "load", (client) ->
			client.on "complete", (client, args) ->
				jGrowl.show text.get("copiedToClipboard")

			client.on "dataRequested", (client, args) ->
				client.setText fnText(this)

		client.on "wrongflash noflash", ->
			jGrowl.show text.get("copyToClipboardFailed")
			client.destroy()
			ZeroClipboard = null
	else
		jqElem.click (e) ->
			e.preventDefault()
			jGrowl.show text.get("copyToClipboardFailed")
			return

module.exports.init = init
module.exports.bind = bind
module.exports.setText = setText
