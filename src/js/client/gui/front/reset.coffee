###
# PassDeposit #
Reset user dialog

Created by Max Geissler
###

username = require "./username"
global = require "../global"
core = require "../../core"
register = require "./register"

resetSuccess = false
resetKey = null

reset = ->
	resetSuccess = false

	email = $("#registerEmail").val()
	password = $("#registerPass").val()
	passwordHint = $("#registerPassHint").val()

	core.user.reset resetKey, email, password, passwordHint, (response) ->
		$("#resetDialog").modal "hide"

		if response.status == "success"
			# Save username
			username.save()

			resetSuccess = true
		else
			global.jGrowl.show global.text.get("resetFailed", response.status)

	# Disable reset button
	$("#resetDialog .btn.reset").attr("disabled", true)

setResetForm = (email) ->
	# This function rebuilds the register form
	# to a reset form

	# Set email field and lock it
	emailField = $("#registerEmail")
	emailField.val(email)
	emailField.attr("disabled", true)

	# Remove register button
	$("#registerButton").hide()

	# Show reset button
	resetButton = $("#resetButton")
	resetButton.show()

	# Change tab text
	$("#frontNav li a[href=#register]").text(resetButton.text())

	# Do not call register submit handler
	$("#register").off "submit.register"

	# Add handler for submit event
	$("#register").on "submit.reset", (e) ->
		e.preventDefault()

		if register.validate(true)
			$("#resetDialog").modal "show"
		else
			global.setFormFocus "#register"

		return

	# Show reset/register tab
	global.navPills.change "#frontNav", "#register", false

check = ->
	# Check if reset dialog is requested

	# Get URL
	url = window.location.href

	# Get reset key from URL:
	# https://www.example.com/reset-mail@example.com-1437b4359ebc2e949fb56cf835150482c6ef0942
	re = /\/reset-(.+)-(([a-f]|[0-9])+)/ig
	result = re.exec(url)

	if result?
		# Get values from regex
		email = result[1]
		resetKey = result[2]

		if resetKey?
			# Show reset form
			setResetForm(email)

init = ->
	$("#resetDialog").on "hidden", ->
		if resetSuccess
			# Reset reset form
			$("#register").each ->
				@reset()

				# Continue with loop
				return true
			
			# Show confirmation message
			global.jGrowl.show global.text.get("resetSuccessful"),
				sticky: true

			# Show login tab
			global.navPills.change "#frontNav", "#login", false

		return

	$("#resetDialog .btn.reset").click (e) ->
		e.preventDefault()
		reset()
		return

	check()

module.exports.init = init
