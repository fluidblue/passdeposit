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

			console.log "load"

			client.on "complete", (client, args) ->
				console.log "complete"
				jGrowl.show text.get("copiedToClipboard")
				return

			client.on "dataRequested", (client, args) ->
				console.log "dataRequested"
				client.setText fnText(this)
				return

			# client.on "mouseover", (client) ->
			# 	client.setText "text0"
			# 	console.log "mouse over"
			# 	return

			# client.on "mouseout", (client) ->
			# 	client.setText "text1"
			# 	console.log "mouse out"
			# 	return

			# client.on "mousedown", (client) ->
			# 	client.setText "text2"
			# 	console.log "mouse down"
			# 	return

			# client.on "mouseup", (client) ->
			# 	client.setText "text3"
			# 	console.log "mouse up"
			# 	return
		else
			isReady = false

	client.on "wrongflash noflash", ->
		isReady = false
		client.destroy()
		client = null
		throw new Error("Clipboard not working")

	# Testing
	$("#loginButton").on "mouseover", (e) ->
		$(this).css "color", "red"
		text = (new Date()).toString()

		activate this, text

activate = (elem, text) ->
	if isReady
		client.setText text
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
