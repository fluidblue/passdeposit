###
# PassDeposit #
Reset user dialog

Created by Max Geissler
###

global = require "../global"

setResetForm = (resetKey) ->
	# This function rebuilds the register form
	# to a reset form

	# Remove email field
	$("#registerEmail").closest(".itemField").remove()

	# Remove register button
	$("#registerButton").hide()

	# Show reset button
	resetButton = $("#resetButton")
	resetButton.show()

	# Change tab text
	$("#frontNav li a[href=#register]").text(resetButton.text())

	# TODO: Save resetKey

	# Do not call register submit handler
	$("#register").off "submit.register"

	# Add handler for submit event
	$("#register").on "submit.reset", (e) ->
		e.preventDefault()

		# TODO: Validation
		$("#resetDialog").modal "show"

		return

	# Show reset/register tab
	global.navPills.change "#frontNav", "#register", false

check = ->
	# Check if reset dialog is requested

	# Get URL
	url = window.location.href

	# Get reset key from URL:
	# https://www.example.com/reset-1437b4359ebc2e949fb56cf835150482c6ef0942
	re = /(\/reset-)(([a-f]|[0-9])+)/ig
	result = re.exec(url)

	if result?
		# Third element contains key
		resetKey = result[2]

		if resetKey?
			# Show reset form
			setResetForm(resetKey)

init = ->
	# $("#resetDialog").submit (e) ->
	# 	e.preventDefault()

	# 	# TODO
	# 	alert "Not implemented"

	# 	return

	# $("#resetDialog").on "shown", ->
	# 	$("#resetDialog input.email").focus()
	# 	return

	check()

module.exports.init = init
