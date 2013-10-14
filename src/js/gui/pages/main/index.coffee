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

# Initializes main page
init = ->
	optionsDialog.init()
	donationDialog.init()
	lockDialog.init()
	logout.init()
	clipboard.init()
	btnAdd.init()
	search.init()

module.exports.init = init
