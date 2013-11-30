###
# PassDeposit #
User management module

Created by Max Geissler
###

crypt = require "./crypt"
command = require "./command"

# User's ID, current session and plaintext master password
# These values are only set if the user is logged in.
userid = null
session = null
masterpassword = null

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
				# Save userID and session
				userid = response.userid
				session = response.session
				masterpassword = password

			callback(response)

logout = ->
	# Clear values
	userid = null
	session = null
	masterpassword = null

getID = ->
	return userid

getSession = ->
	return session

getPassword = ->
	return masterpassword

module.exports.create = create
module.exports.login = login
module.exports.logout = logout
module.exports.getID = getID
module.exports.getSession = getSession
module.exports.getPassword = getPassword
