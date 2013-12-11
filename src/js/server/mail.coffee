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
	try
		if !transport?
			throw "Not connected to mail transport"

		mailOptions =
			# TODO
			#from: "Test <" + config.get().mail + ">"
			to: to
			subject: subject
			text: text

		transport.sendMail mailOptions, (error, response) ->
			if error
				throw error
	catch e
		log.error "Could not send mail to " + to + " (" + e + ")"

	return

init = ->
	try
		# Use sendmail
		transport = nodemailer.createTransport "sendmail"

		# Connect to local SMTP server
		# transport = nodemailer.createTransport "SMTP",
		# 	host: "localhost"
		# 	maxConnections: 2

		# TODO: Check ECONNREFUSED error
	catch e
		transport = null

module.exports.isReady = isReady
module.exports.send = send
module.exports.init = init
