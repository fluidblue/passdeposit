###
# PassDeposit #
Front page

Created by Max Geissler
###

login = require "./login"
register = require "./register"
pwforgot = require "./pwforgot"
username = require "./username"
global = require "../global"

init = ->
	username.load()
	global.setFormFocus "#login" # TODO: Move to page change function

	login.init()
	register.init()
	pwforgot.init()

module.exports.init = init
