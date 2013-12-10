###
# PassDeposit #
Login tab

Created by Max Geissler
###

username = require "./username"
global = require "../global"
core = require "../../core"

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
		if response.status != "success"
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

		username.save()

		# Load items from database
		core.items.load (response) ->
			if response.status != "success"
				# TODO
				alert "Failed to load items from DB"
				return

			# Switch to mainpage
			global.pageChange.change "#mainpage", ->
				# Empty password field
				$("#loginPass").val ""
			, ->
				$("#search").focus()

# Initializes front page
init = ->
	$("#login").submit (e) ->
		e.preventDefault()
		login()
		return

module.exports.init = init
