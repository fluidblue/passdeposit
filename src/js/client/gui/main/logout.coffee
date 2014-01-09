###
# PassDeposit #
Logout functions

Created by Max Geissler
###

global = require "../global"
itemlist = require "./itemlist"
search = require "./search"
core = require "../../core"
options = require "./options"

setLogoutButtonDisabled = (disabled) ->
	$("#btnLogout").attr("disabled", disabled)

logout = ->
	# Disable logout button
	setLogoutButtonDisabled(true)

	# Close all jGrowl messages
	global.jGrowl.closeAll()
	
	# Switch to frontpage
	global.pageChange.change "#frontpage", ->
		# Clear all data
		core.user.logout()
		itemlist.clear(true)

		# Reset dialogs
		search.reset()
		options.reset()

		# Enable logout button
		setLogoutButtonDisabled(false)

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
