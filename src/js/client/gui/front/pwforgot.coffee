###
# PassDeposit #
Password forgot dialog

Created by Max Geissler
###

global = require "../global"
core = require "../../core"
shared = require "../../../shared"

init = ->
	$("#pwForgotDialog").submit (e) ->
		e.preventDefault()

		emailField = $("#pwForgotDialog input.email")
		email = emailField.val()

		if !shared.validation.email(email)
			# Notify user
			global.form.setInputInvalid(emailField)
			return

		core.user.sendPasswordHint email, (response) ->
			$("#pwForgotDialog").one "hidden", ->
				if response.status == "success"
					# Clear field
					emailField.val ""
					
					# Show notification
					global.jGrowl.show global.text.get("passwordHintSent")
				else
					# Show notification
					global.jGrowl.show global.text.get("passwordHintFailed")

				return

			# Close dialog
			$("#pwForgotDialog").modal "hide"

		return

	$("#pwForgotDialog").on "shown", ->
		$("#pwForgotDialog input.email").focus()
		return

module.exports.init = init
