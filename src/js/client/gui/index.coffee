###
# PassDeposit #
GUI API

Created by Max Geissler
###

features = require "./features"
global = require "./global"
front = require "./front"
main = require "./main"

init = ->
	features.init()

	global.init()
	front.init()
	main.init()

module.exports.init = init
