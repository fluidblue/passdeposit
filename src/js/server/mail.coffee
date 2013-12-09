###
# PassDeposit #

Created by Max Geissler
###

nodemailer = require "nodemailer"
config = require "./config"
log = require "./log"

transport = null

send = (to, subject, message, callback) ->
	mailOptions =
		from: "PassDeposit <" + config.get().mail + ">"
		to: to
		subject: subject
		text: message

	errorHandler = (error, response) ->
		if error
			callback(true)
		else
			log.error "Could not send mail to " + to + " (" + response.message + ")"
			callback(false)

	if transport?
		try
			transport.sendMail mailOptions, errorHandler
		catch e
			errorHandler true,
				message: e
	else
		errorHandler true,
			message: "Not connected to mail relay"

init = ->
	transport = nodemailer.createTransport "sendmail"
	
	# transport = nodemailer.createTransport "SMTP",
	# 	host: "localhost"
	# 	maxConnections: 2

module.exports.send = send
module.exports.init = init
