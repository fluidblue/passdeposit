###
# PassDeposit #
Logout functions

Created by Max Geissler
###

setFormFocus = require "../../components/set-form-focus"
jGrowl = require "../../components/jgrowl-extend"
config = require "../../../config"
itemlist = require "../../itemlist"

logout = ->
	# Close all jGrowl messages
	jGrowl.closeAll()
	
	# Switch to frontpage
	$("#mainpage").fadeOut config.animations.pageChangeDuration, ->
		# TODO: Clean up data!
		itemlist.clear(true)

		# Show frontpage
		$("#frontpage").fadeIn config.animations.pageChangeDuration
		setFormFocus "#login"

init = ->
	$("#btnLogout").click (e) ->
		logout()

		e.preventDefault()
		return

module.exports.init = init
module.exports.logout = logout
