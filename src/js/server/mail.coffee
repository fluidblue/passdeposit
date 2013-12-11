###
# PassDeposit #

Created by Max Geissler
###

nodemailer = require "nodemailer"
config = require "./config"
log = require "./log"

transport = null

isReady = ->
	return transport?

send = (to, subject, text) ->
	mailError = (e) ->
		log.error "Could not send mail to " + to + " (" + e + ")"

	if !transport?
		mailError "Not connected to mail transport"
		return

	mailOptions =
		# TODO
		#from: "Test <" + config.get().mail + ">"
		to: to
		subject: subject
		text: text

	transport.sendMail mailOptions, (error, response) ->
		if error
			mailError(error)

	return

init = ->
	# Use sendmail
	transport = nodemailer.createTransport "sendmail"

	# Connect to local SMTP server
	# transport = nodemailer.createTransport "SMTP",
	# 	host: "localhost"
	# 	maxConnections: 2

module.exports.isReady = isReady
module.exports.send = send
module.exports.init = init
