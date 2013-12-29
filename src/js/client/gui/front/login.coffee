###
# PassDeposit #
Login tab

Created by Max Geissler
###

username = require "./username"
global = require "../global"
core = require "../../core"

load = ->
	loaded = false
	frontHidden = false
	loadResponse = null

	# Define loadHandler
	loadHandler = (response) ->
		if response.status != "success"
			# Go back to frontpage and show error
			global.pageChange.change "#frontpage", null, ->
				global.form.focus "#login"
				global.jGrowl.show global.text.get("dbLoadFailed", response.status)
				return true
			
			return

		# Switch to mainpage
		global.pageChange.change "#mainpage", ->
			# Empty password field
			$("#loginPass").val ""
			return true
		, ->
			# Focus search field
			$("#search").focus()
			return true

	# Switch to loading page
	global.pageChange.change "#loadpage", ->
		frontHidden = true

		if loaded
			loadHandler(loadResponse)
			return false

		return true

	# Load items from database
	core.items.load (response) ->
		loaded = true

		if frontHidden
			loadHandler(response)
		else
			loadResponse = response

login = ->
	# Dismiss registration notification(s), if open
	global.jGrowl.closeAll()

	# Get fields
	passField = $("#loginPass")
	userField = $("#loginUser")

	# Get login data
	email = userField.val()
	password = passField.val()
	
	core.user.login email, password, (response) ->
		if response.status == "auth:failed"
			fnInvalid = ->
				userField.removeClass "invalidInput"
				userField.off "keypress.loginfailed change.loginfailed input.loginfailed"

				passField.removeClass "invalidInput"
				passField.off "keypress.loginfailed change.loginfailed input.loginfailed"
				return

			userField.addClass "invalidInput"
			userField.one "keypress.loginfailed change.loginfailed input.loginfailed", fnInvalid

			passField.addClass "invalidInput"
			passField.one "keypress.loginfailed change.loginfailed input.loginfailed", fnInvalid

			passField.val ""

			if email.length == 0
				userField.focus()
			else
				passField.focus()

			return
		else if response.status != "success"
			# Notify user
			global.jGrowl.show global.text.get("loginFailed", response.status)
			return

		# Save username
		username.save()

		# Start loading
		load()

# Initializes front page
init = ->
	$("#login").submit (e) ->
		e.preventDefault()
		login()
		return

	username.load()
	global.form.focus "#login"

module.exports.init = init
