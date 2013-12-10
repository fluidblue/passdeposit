###
# PassDeposit #
Password forgot dialog

Created by Max Geissler
###

global = require "../global"
core = require "../../core"

init = ->
	$("#pwForgotDialog").submit (e) ->
		e.preventDefault()

		emailField = $("#pwForgotDialog input.email")

		core.user.sendPasswordHint emailField.val(), (response) ->
			if response.status == "success"
				# Clear field
				$("#pwForgotDialog").one "hidden", ->
					emailField.val ""
					
					# Show notification
					global.jGrowl.show global.text.get("passwordHintSent")

					return

				# Close dialog
				$("#pwForgotDialog").modal "hide"
			else
				# Notify user
				global.setInputInvalid(emailField)

		return

	$("#pwForgotDialog").on "shown", ->
		$("#pwForgotDialog input.email").focus()
		return

module.exports.init = init
