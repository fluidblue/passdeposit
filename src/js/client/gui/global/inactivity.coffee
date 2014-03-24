###
# PassDeposit #
Inactivity timer

Created by Max Geissler
###

# Timeout given in minutes
start = (timeout, callback) ->
	# Convert to seconds
	timeout *= 60

	timer = null
	idleCounter = 0

	check = ->
		idleCounter++

		if idleCounter >= timeout
			window.clearInterval timer

			$(document).off "click.inactivity"
			$(document).off "mousemove.inactivity"
			$(document).off "keypress.inactivity"

			callback()

	reset = ->
		idleCounter = 0
		return

	$(document).on "click.inactivity", reset
	$(document).on "mousemove.inactivity", reset
	$(document).on "keypress.inactivity", reset

	timer = window.setInterval check, 1000

module.exports.start = start
