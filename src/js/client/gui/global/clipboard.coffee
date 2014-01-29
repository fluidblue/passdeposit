###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"
global = require "."

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
				global.jGrowl.show global.text.get("copiedToClipboard")
				return

			client.on "dataRequested", (client, args) ->
				console.log "dataRequested"
				client.setText fnText(this)
				return

			client.on "mouseover", (client) ->
				console.log "mouse over"
				return

			client.on "mouseout", (client) ->
				console.log "mouse out"
				return

			client.on "mousedown", (client) ->
				console.log "mouse down"
				return

			client.on "mouseup", (client) ->
				console.log "mouse up"
				return
		else
			isReady = false

		return

	client.on "wrongflash noflash", ->
		isReady = false
		client.destroy()
		client = null
		throw new Error("Clipboard not working")

	# Testing
	$("#loginButton").on "mouseover", (e) ->
		$(this).css "color", "red"

		activate this, (elem) ->
			return (new Date()).toString()

activate = (elem, fnText_) ->
	console.log "activate"

	fnText = fnText_

	if isReady
		ZeroClipboard.activate(elem)
	else
		# Make sure, that only one event handler is bound to the click event.
		elem = $(elem)
		elem.off "click.clipboard"
		elem.on "click.clipboard", (e) ->
			e.preventDefault()
			global.jGrowl.show global.text.get("copyToClipboardFailed")
			return

deactivate = ->
	if isReady
		ZeroClipboard.deactivate()

module.exports.init = init
module.exports.activate = activate
module.exports.deactivate = deactivate
