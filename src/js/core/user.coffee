###
# PassDeposit #
User management module

Created by Max Geissler
###

crypt = require "./crypt"

create = (email, password, passwordHint, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	key = crypt.key(password, email)

	# Send command to server
	command.send
		cmd: "user.create"
		data:
			email: email
			key: key
			passwordHint: passwordHint
		callback: callback

login = (email, password, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	key = crypt.key(password, email)

	# Send command to server
	command.send
		cmd: "user.login"
		data:
			email: email
			key: key
		callback: (response) ->
			if response.status == "success"
				# Save session
				command.setSession(response.session)

			callback(response)

module.exports.create = create
module.exports.login = login
