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

# Function that returns the text being copied to the clipboard
fnText = null

client = null
isReady = false

init = ->
	# Set global ZeroClipboard configuration
	ZeroClipboard.config
		moviePath: "media/zeroclipboard.swf"
		cacheBust: false
		forceHandCursor: true
		autoActivate: false
		debug: true # Verbose mode

	# Create ZeroClipboard client
	client = new ZeroClipboard()

	client.on "load", (client) ->
		if client != null
			isReady = true

			client.on "complete", (client, args) ->
				jGrowl.show text.get("copiedToClipboard")

			client.on "dataRequested", (client, args) ->
				client.setText fnText(this)
		else
			isReady = false

	client.on "wrongflash noflash", ->
		isReady = false
		client.destroy()
		client = null

	# Testing
	$("#loginButton").on "mouseover", (e) ->
		activate this, (elem) ->
			$(elem).css "color", "red"
			return "Test: " + (new Date()).toString()

activate = (elem, fnText_) ->
	fnText = fnText_

	if isReady
		ZeroClipboard.activate(elem)
	else
		# TODO: Check performance of off,on
		elem.off "click.clipboard"
		elem.on "click.clipboard", (e) ->
			e.preventDefault()
			jGrowl.show text.get("copyToClipboardFailed")
			return

deactivate = ->
	if isReady
		ZeroClipboard.deactivate()

module.exports.init = init
module.exports.activate = activate
module.exports.deactivate = deactivate
