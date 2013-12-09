###
# PassDeposit #
Register tab

Created by Max Geissler
###

username = require "./username"
global = require "../global"
core = require "../../core"

# TODO: Unused?
showRegisterErrorTip = (element, message) ->
	# TODO: Not working, if another popover is already attached to element
	content = "<div class=\"errorPopover\">" + message + "</div>"

	options =
		trigger: "manual"
		placement: "left"
		html: true
		content: content

	$(element).popover options
	$(element).popover "show"

setInputInvalid = (jqElem) ->
	jqElem.addClass "invalidInput"
	jqElem.one "keypress", ->
		jqElem.removeClass "invalidInput"
		return

checkNotEmpty = (jqElem) ->
	if jqElem.val().length == 0
		setInputInvalid jqElem
		return false
	return true

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

	$("#register").submit (e) ->
		e.preventDefault()

		if checkNotEmpty($("#registerEmail")) & checkNotEmpty($("#registerPass")) &
		checkNotEmpty($("#registerPassRepeat")) & checkNotEmpty($("#registerPassHint"))
			$("#registerDialog").modal "show"
		else
			global.setFormFocus "#register"

		return

	registerSuccess = false

	$("#registerDialog").on "hidden", ->
		if registerSuccess
			# Fill in login information
			$("#loginUser").val $("#registerEmail").val()
			$("#loginPass").val ""
			
			# Reset registration form
			$("#register").each ->
				@reset()

				# Continue with loop
				return true
			
			# Save username
			username.save()
			
			# Show confirmation message
			global.jGrowl.show global.text.get("loginSuccessful"),
				sticky: true

			# Show login tab
			global.navPills.trigger "#frontNav", "#login"

		return

	$("#registerDialog .btn.register").click (e) ->
		e.preventDefault()

		registerSuccess = false

		email = $("#registerEmail").val()
		password = $("#registerPass").val()
		passwordHint = $("#registerPassHint").val()

		core.user.create email, password, passwordHint, (response) ->
			if response.status == "success"
				registerSuccess = true
			else
				# TODO
				alert "Failed to create user: " + response.status

		$("#registerDialog").modal "hide"

		return

module.exports.init = init
