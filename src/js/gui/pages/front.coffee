###
# PassDeposit #
Front page initialization

Created by Max Geissler
###

setFormFocus = require "../components/set-form-focus"
config = require "../../config"
navPills = require "../components/nav-pills"
jGrowl = require "../components/jgrowl-extend"

loadUsername = ->
	$("#loginUser").val $.totalStorage("username")

saveUsername = ->
	$.totalStorage "username", $("#loginUser").val()

loginUser = ->
	# Dismiss registration notification(s), if open
	jGrowl.closeAll()

	#$("#loginPass").val().length == 0
		#$('#loginPass').addClass('invalidInput');
		#return false;
	
	#$.post('passdeposit.php',
	#		{
	#			userName : this.userName,
	#			pass: this.passHash
	#		}
	#	);
	
	saveUsername()
	
	# Switch to mainpage
	$("#frontpage").fadeOut config.animations.pageChangeDuration, ->
		$("#mainpage").fadeIn config.animations.pageChangeDuration
		$("#search").focus()
		
		# Empty password field
		$("#loginPass").val ""

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

checkNotEmpty = (jqElem) ->
	if jqElem.val().length == 0
		setInputInvalid jqElem
		return false
	return true

initRegisterTooltips = ->
	fnContent = ->
		$("#text ." + $(this).attr("id") + "Info").html()

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
		loginUser()

		e.preventDefault()
		return

	$("#register").submit (e) ->
		if checkNotEmpty($("#registerEmail")) & checkNotEmpty($("#registerPass")) & checkNotEmpty($("#registerPassRepeat")) & checkNotEmpty($("#registerPassHint"))
			$("#registerDialog").modal "show"
		else
			setFormFocus "#login" # TODO: Not working

		e.preventDefault()
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
			$.jGrowl $("#text .loginSuccessful").html(),
				sticky: true

			# Show login tab
			navPills.trigger "#frontNav", "#login"

		return

	$("#registerDialog .modal-footer .register").click (e) ->
		registerSuccess = false
		
		#alert('Not implemented.');

		registerSuccess = true
		$("#registerDialog").modal "hide"

		e.preventDefault()
		return

	$("#pwForgotDialog").submit (e) ->
		alert "Not implemented."

		$("#pwForgotDialog input.email").val ""
		$("#pwForgotDialog").modal "hide"

		e.preventDefault()
		return

	$("#pwForgotDialog").on "shown", ->
		$("#pwForgotDialog input.email").focus()
		return

module.exports.init = init
