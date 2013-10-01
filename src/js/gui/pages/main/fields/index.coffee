###
# PassDeposit #
Fields

Created by Max Geissler
###

buttons = require "./buttons"
menu = require "./menu"

init = ->
	buttons.init()
	menu.init()

module.exports.init = init
