###
# PassDeposit #
Front page initialization

Created by Max Geissler
###

setFormFocus = require "../components/set-form-focus"
config = require "../../config"
navPills = require "../components/nav-pills"
jGrowl = require "../components/jgrowl-extend"
text = require "../components/text"
core = require "../../core"

loadUsername = ->
	$("#loginUser").val $.totalStorage("username")

saveUsername = ->
	$.totalStorage "username", $("#loginUser").val()

loginUser = ->
	# Dismiss registration notification(s), if open
	jGrowl.closeAll()

	# Get fields
	passField = $("#loginPass")
	userField = $("#loginUser")

	# Get login data
	email = userField.val()
	password = passField.val()
	
	core.user.login email, password, (response) ->
		if response.status != "success"
			# Notify user
			userField.addClass "invalidInput"
			userField.one "keypress.loginfailed", ->
				userField.removeClass "invalidInput"
				return

			passField.addClass "invalidInput"
			passField.one "keypress.loginfailed", ->
				passField.removeClass "invalidInput"

				userField.removeClass "invalidInput"
				userField.off "keypress.loginfailed"
				return

			passField.val ""

			if email.length == 0
				userField.focus()
			else
				passField.focus()

			return

		saveUsername()

		# Load items from database
		core.items.load (response) ->
			if response.status != "success"
				# TODO
				alert "Failed to load items from DB"
				return

			# Switch to mainpage
			$("#frontpage").fadeOut config.animations.pageChangeDuration, ->
				# Empty password field
				$("#loginPass").val ""

				# Show mainpage
				$("#mainpage").fadeIn config.animations.pageChangeDuration
				$("#search").focus()

				return

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
		text.get($(this).attr("id") + "Info")

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
	loadUsername()
	setFormFocus "#login" # TODO: Move to page change function
	initRegisterTooltips()

	$("#login").submit (e) ->
		e.preventDefault()
		loginUser()
		return

	$("#register").submit (e) ->
		e.preventDefault()

		if checkNotEmpty($("#registerEmail")) & checkNotEmpty($("#registerPass")) & checkNotEmpty($("#registerPassRepeat")) & checkNotEmpty($("#registerPassHint"))
			$("#registerDialog").modal "show"
		else
			setFormFocus "#register"

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
			saveUsername()
			
			# Show confirmation message
			$.jGrowl text.get("loginSuccessful"),
				sticky: true

			# Show login tab
			navPills.trigger "#frontNav", "#login"

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

	$("#pwForgotDialog").submit (e) ->
		e.preventDefault()

		alert "Not implemented."

		$("#pwForgotDialog input.email").val ""
		$("#pwForgotDialog").modal "hide"

		return

	$("#pwForgotDialog").on "shown", ->
		$("#pwForgotDialog input.email").focus()
		return

module.exports.init = init
