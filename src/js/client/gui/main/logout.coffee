###
# PassDeposit #
Logout functions

Created by Max Geissler
###

global = require "../global"
itemlist = require "./itemlist"
core = require "../../core"

logout = ->
	# Close all jGrowl messages
	global.jGrowl.closeAll()
	
	# Switch to frontpage
	global.pageChange.change "#frontpage", ->
		# Clear all data
		core.user.logout()
		itemlist.clear(true)

		# Reset search field
		$("#search").val ""

		# TODO: Reset dialogs

		return true
	, ->
		# Focus login form
		global.form.focus "#login"

init = ->
	$("#btnLogout").click (e) ->
		e.preventDefault()
		logout()
		return

module.exports.init = init
module.exports.logout = logout
