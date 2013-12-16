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
resetActive = false

isActive = ->
	return resetActive

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
		else if response.status == "time:failed"
			# resetKey is not valid anymore
			global.jGrowl.show global.text.get("resetTimeout")
		else
			global.jGrowl.show global.text.get("resetFailed", response.status)

	# Disable reset button
	$("#resetDialog .btn.reset").attr("disabled", true)

setResetForm = (isReset) ->
	# This function modifies the register form
	# to be either the real register form
	# or the reset form.

	resetActive = isReset

	if isReset
		# Disable email field
		$("#registerEmail").attr("disabled", true)

		# Show submit button
		submitButton = $("#resetButton")
		submitButton.show()

		# Change tab text
		$("#frontNav li a[href=#register]").text(submitButton.text())

		# Hide other submit button
		$("#registerButton").hide()

		# Set mode
		$(this).data("mode", "reset")
	else
		# Enable email field
		$("#registerEmail").removeAttr("disabled")

		# Show submit button
		submitButton = $("#registerButton")
		submitButton.show()

		# Change tab text
		$("#frontNav li a[href=#register]").text(submitButton.text())

		# Hide other submit button
		$("#resetButton").hide()

		# Set mode
		$("#register").attr("data-mode", "register")

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
			setResetForm(true)
			
			# Show email address
			$("#registerEmail").val(email)

			# Show reset/register tab
			global.navPills.change "#frontNav", "#register", false

init = ->
	$("#register").on "submit.reset", (e) ->
		if !resetActive
			return

		e.preventDefault()

		if register.validate(true)
			$("#resetDialog").modal "show"
		else
			global.setFormFocus "#register"

		return

	$("#resetDialog").on "show", ->
		# Enable reset button
		$(this).find(".btn.reset").attr("disabled", false)
		return

	$("#resetDialog").on "hidden", ->
		if resetSuccess
			# Fill in login information
			$("#loginUser").val $("#registerEmail").val()
			$("#loginPass").val ""

			# Reset form
			$("#register")[0].reset()
			
			# Show confirmation message
			global.jGrowl.show global.text.get("resetSuccessful"),
				sticky: true

			# Show login tab
			global.navPills.change "#frontNav", "#login", false

			# Show register form
			setResetForm(false)

			# Modify URL
			window.history.replaceState(null, null, ".")

		return

	$("#resetDialog .btn.reset").click (e) ->
		e.preventDefault()
		reset()
		return

	check()

module.exports.isActive = isActive
module.exports.init = init
