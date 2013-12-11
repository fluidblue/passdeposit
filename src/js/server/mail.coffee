###
# PassDeposit #

Created by Max Geissler
###

email = require "email"
config = require "./config"
log = require "./log"

Email = email.Email

send = (to, subject, text, callback) ->
	try
		mail = new Email
			from: "PassDeposit <" + config.get().mail + ">"
			to: to
			subject: subject
			body: text

		mail.send()

		callback(null)
	catch e
		log.error "Could not send mail to " + to + " (" + e + ")"
		callback(e)

	return

module.exports.send = send
