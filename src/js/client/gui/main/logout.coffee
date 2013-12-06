###
# PassDeposit #
Logout functions

Created by Max Geissler
###

global = require "../global"
config = require "../../../config"
itemlist = require "./itemlist"
core = require "../../core"

logout = ->
	# Close all jGrowl messages
	global.jGrowl.closeAll()
	
	# Switch to frontpage
	$("#mainpage").fadeOut config.animations.pageChangeDuration, ->
		# Clear all data
		core.user.logout()
		itemlist.clear(true)

		# TODO: Reset dialogs

		# Show frontpage
		$("#frontpage").fadeIn config.animations.pageChangeDuration
		global.setFormFocus "#login"

init = ->
	$("#btnLogout").click (e) ->
		e.preventDefault()
		logout()
		return

module.exports.init = init
module.exports.logout = logout
