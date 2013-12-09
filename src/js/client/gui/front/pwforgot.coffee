###
# PassDeposit #
Password forgot dialog

Created by Max Geissler
###

init = ->
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
