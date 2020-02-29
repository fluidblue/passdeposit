###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"
global = require "."

# This fixes a bug in ZeroClipboard, where the load event never gets fired.
window.require = require

# Holds event handler for active element
options = {}

client = null
isReady = false

copyText = (input) ->
	# Uses html5 clipboard api

	# Select the text field
	input.select()

	# For mobile devices
	if input.setSelectionRange?
		input.setSelectionRange(0, 99999)

	# Copy the text inside the field
	document.execCommand("copy")

	# TODO: Remove
	value = input.val()
	console.log(value)

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

	client.on "load", (client_) ->
		if client != null
			isReady = true

			client.on "complete", (client, args) ->
				global.jGrowl.show global.text.get("copiedToClipboard")
				return

			client.on "dataRequested", (client, args) ->
				client.setText options.dataRequested(this)
				return

			client.on "mouseover", (client) ->
				if options.mouseover?
					options.mouseover(this)
				return

			client.on "mouseout", (client) ->
				if options.mouseout?
					options.mouseout(this)
				ZeroClipboard.deactivate()
				return

			client.on "mousedown", (client) ->
				if options.mousedown?
					options.mousedown(this)
				return

			client.on "mouseup", (client) ->
				if options.mouseup?
					options.mouseup(this)
				return
		else
			isReady = false

		return

	client.on "wrongflash noflash", ->
		isReady = false
		client.destroy()
		client = null
		throw new Error("Clipboard not working")

activate = (options_) ->
	options = options_

	if isReady
		ZeroClipboard.activate(options.element)
	else
		elem = $(options.element)

		elem.off "click.clipboard"
		elem.on "click.clipboard", (e) ->
			e.preventDefault()
			global.jGrowl.show global.text.get("copyToClipboardFailed")
			return

		bind = (eventName) ->
			nsEvent = eventName + ".clipboard"
			elem.off nsEvent
			if options[eventName]?
				elem.on nsEvent, (e) ->
					options[eventName](this)
					return

		bind "mouseover"
		bind "mouseout"
		bind "mousedown"
		bind "mouseup"

deactivate = ->
	if isReady
		ZeroClipboard.deactivate()

		# Fire mouseout event
		if options.mouseout?
			options.mouseout(options.element)

module.exports.init = init
module.exports.activate = activate
module.exports.deactivate = deactivate
module.exports.copyText = copyText
