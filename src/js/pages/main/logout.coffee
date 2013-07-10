###
# PassDeposit #
Logout functions

Created by Max Geissler
###

setFormFocus = require "../../components/set-form-focus"
jGrowl = require "../../components/jgrowl-extend"
config = require "../../components/config"

logout = ->
	# TODO: Clean up data!
	
	# Close all jGrowl messages
	jGrowl.closeAll()
	
	# Switch to frontpage
	$("#mainpage").fadeOut config.animations.pageChangeDuration, ->
		$("#frontpage").fadeIn config.animations.pageChangeDuration
		setFormFocus "#login"

init = ->
	$("#btnLogout").click (e) ->
		logout()

		e.preventDefault()
		return

module.exports.init = init
module.exports.logout = logout