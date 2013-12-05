###
# PassDeposit #
GUI API

Created by Max Geissler
###

global = require "./global"
front = require "./front"
main = require "./main"

init = ->
	global.init()
	front.init()
	main.init()

module.exports.init = init
