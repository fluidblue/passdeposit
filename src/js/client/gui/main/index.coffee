###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

optionsDialog = require "./options"
donationDialog = require "./donations"
lockDialog = require "./lock"
logout = require "./logout"
clipboard = require "./clipboard"
btnAdd = require "./btnAdd"
search = require "./search"
itemlist = require "./itemlist"

# Initializes main page
init = ->
	optionsDialog.init()
	donationDialog.init()
	lockDialog.init()
	logout.init()
	clipboard.init()
	btnAdd.init()
	search.init()
	itemlist.init()

module.exports.init = init
