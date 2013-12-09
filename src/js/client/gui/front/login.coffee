###
# PassDeposit #
Login tab

Created by Max Geissler
###

username = require "./username"
global = require "../global"
config = require "../../../config"
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

		username.save()

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

# Initializes front page
init = ->
	$("#login").submit (e) ->
		e.preventDefault()
		login()
		return

module.exports.init = init
