###
# PassDeposit #
Lock dialog

Created by Max Geissler
###

require "../../lib/jquery"
require "../../lib/bootstrap"
logout = require("./logout").logout

lock = ->
	# TODO: Hide data!
	$("#lockDialog").modal "show"

init = ->
	$("#btnLock").click (e) ->
		lock()

		e.preventDefault()
		return

	$("#lockDialog").on "shown", ->
		$("#lockDialog input.pass").focus()
		return

	$("#lockDialog").submit (e) ->
		# Remove password
		$("#lockDialog input.pass").val ""
		
		# Close dialog
		$("#lockDialog").modal "hide"

		e.preventDefault()
		return

	$("#lockDialog .btnLogout").click (e) ->
		# Remove password, if any
		$("#lockDialog input.pass").val ""
		
		# Logout after dialog closes
		$("#lockDialog").on "hidden.logout", ->
			$("#lockDialog").off "hidden.logout"
			logout()
		
		# Close dialog
		$("#lockDialog").modal "hide"

		e.preventDefault()
		return

module.exports.init = init
module.exports.lock = lock