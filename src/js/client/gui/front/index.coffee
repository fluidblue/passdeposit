###
# PassDeposit #
Front page

Created by Max Geissler
###

login = require "./login"
register = require "./register"
pwforgot = require "./pwforgot"
reset = require "./reset"

init = ->
	login.init()
	register.init()
	pwforgot.init()
	reset.init()

module.exports.init = init
