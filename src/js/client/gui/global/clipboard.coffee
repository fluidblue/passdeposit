###
# PassDeposit #
Provide clipboard write access

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"
global = require "."

# This fixes a bug in ZeroClipboard, where the load event never gets fired.
window.ZeroClipboard = ZeroClipboard

init = ->
	ZeroClipboard.config
		moviePath: "media/zeroclipboard.swf"
		cacheBust: false
		forceHandCursor: true # Not working?
		debug: true

	client = new ZeroClipboard(document.getElementById("loginButton"))

	client.on "load", (client) ->
		console.log "movie is loaded"
		
		client.on "complete", (client, args) ->
			# 'this' is the element that was clicked
			this.style.display = "none"
			console.log "Copied text to clipboard: " + args.text

		client.on "dataRequested", (client, args) ->
			client.setText "TestTest"

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
