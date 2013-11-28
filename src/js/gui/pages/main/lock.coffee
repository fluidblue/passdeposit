###
# PassDeposit #
Lock dialog

Created by Max Geissler
###

logout = require("./logout").logout

lock = ->
	# TODO: Hide data!
	$("#lockDialog").modal "show"

init = ->
	$("#btnLock").click (e) ->
		e.preventDefault()
		lock()
		return

	$("#lockDialog").on "shown", ->
		$("#lockDialog input.pass").focus()
		return

	$("#lockDialog").submit (e) ->
		e.preventDefault()

		# Remove password
		$("#lockDialog input.pass").val ""
		
		# Close dialog
		$("#lockDialog").modal "hide"

		return

	$("#lockDialog .btnLogout").click (e) ->
		e.preventDefault()

		# Remove password, if any
		$("#lockDialog input.pass").val ""
		
		# Logout after dialog closes
		$("#lockDialog").on "hidden.logout", ->
			$("#lockDialog").off "hidden.logout"
			logout()
		
		# Close dialog
		$("#lockDialog").modal "hide"

		return

module.exports.init = init
module.exports.lock = lock
