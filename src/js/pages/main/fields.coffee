###
# PassDeposit #
Fields

Created by Max Geissler
###

buttons = require "./fields/buttons"
menu = require "./fields/menu"

init = ->
	buttons.init()
	menu.init()

module.exports.init = init
