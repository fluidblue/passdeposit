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

		username.save()

		# Switch to loadpage
		global.pageChange.change "#loadpage", ->
			# Load items from database
			core.items.load (response) ->
				# Simulate long loading
				# TODO: Remove
				window.setTimeout ->
					if response.status != "success"
						# Go back to frontpage and show error
						global.pageChange.change "#frontpage", null, ->
							global.jGrowl.show global.text.get("dbLoadFailed", response.status)
							global.form.focus "#login"
						return

					# Empty password field
					$("#loginPass").val ""

					# Switch to mainpage
					global.pageChange.change "#mainpage", null, ->
						# Focus search field
						$("#search").focus()
				, 5000

# Initializes front page
init = ->
	$("#login").submit (e) ->
		e.preventDefault()
		login()
		return

	username.load()
	global.form.focus "#login"

module.exports.init = init
