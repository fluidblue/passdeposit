###
# PassDeposit #
Register tab

Created by Max Geissler
###

username = require "./username"
global = require "../global"
core = require "../../core"
shared = require "../../../shared"
reset = require "./reset"

registerSuccess = false

# TODO: Remove?
# showRegisterErrorTip = (element, message) ->
# 	# TODO: Not working, if another popover is already attached to element
# 	content = "<div class=\"errorPopover\">" + message + "</div>"

# 	options =
# 		trigger: "manual"
# 		placement: "left"
# 		html: true
# 		content: content

# 	$(element).popover options
# 	$(element).popover "show"

register = ->
	registerSuccess = false

	email = $("#registerEmail").val()
	password = $("#registerPass").val()
	passwordHint = $("#registerPassHint").val()

	core.user.create email, password, passwordHint, (response) ->
		$("#registerDialog").modal "hide"

		if response.status == "success"
			# Save username
			username.save()

			registerSuccess = true
		else if response.status == "db:duplicate"
			# User has already been registered. Show forgot password dialog.
			$("#pwForgotDialog").modal "show"
			$("#pwForgotDialog input.email").val(email)
		else
			global.jGrowl.show global.text.get("registerFailed", response.status)

	# Disable register button
	$("#registerDialog .btn.register").attr("disabled", true)

validate = (skipEmail = false) ->
	# Define field validation function
	validateField = (jqElem, fn) ->
		if !fn(jqElem.val())
			global.setInputInvalid jqElem
			return false
		
		return true

	# Validation function for password repeat field
	passwordRepeat = (str) ->
		return str == $("#registerPass").val() && str.length > 0

	# Validate all fields and return result
	return (skipEmail || validateField($("#registerEmail"), shared.validation.email)) &
	validateField($("#registerPass"), shared.validation.password) &
	validateField($("#registerPassRepeat"), passwordRepeat) &
	validateField($("#registerPassHint"), shared.validation.passwordHint)

initRegisterTooltips = ->
	fnContent = ->
		global.text.get($(this).attr("id") + "Info")

	options =
		trigger: "focus"
		placement: "right"
		html: true
		content: fnContent

	$("#registerEmail").popover options
	$("#registerPass").popover options
	$("#registerPassRepeat").popover options
	$("#registerPassHint").popover options

# Initializes front page
init = ->
	initRegisterTooltips()

	$("#register").on "submit.register", (e) ->
		# Cancel if the reset form is currently displayed
		if reset.isActive()
			return

		e.preventDefault()

		if validate()
			$("#registerDialog").modal "show"
		else
			global.setFormFocus "#register"

		return

	$("#registerDialog").on "show", ->
		# Enable register button
		$(this).find(".btn.register").attr("disabled", false)
		return

	$("#registerDialog").on "hidden", ->
		if registerSuccess
			# Fill in login information
			$("#loginUser").val $("#registerEmail").val()
			$("#loginPass").val ""
			
			# Reset registration form
			$("#register")[0].reset()
			
			# Show confirmation message
			global.jGrowl.show global.text.get("registerSuccessful"),
				sticky: true

			# Show login tab
			global.navPills.change "#frontNav", "#login", false

		return

	$("#registerDialog .btn.register").click (e) ->
		e.preventDefault()
		register()
		return

module.exports.init = init
module.exports.validate = validate
