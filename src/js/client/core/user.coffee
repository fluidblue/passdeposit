###
# PassDeposit #
User management module

Created by Max Geissler
###

crypt = require "./crypt"
command = require "./command"
itemcache = require "./itemcache"
tagcache = require "./tagcache"

# User's ID, current session and plaintext master password
# These values are only set if the user is logged in.
credentials =
	userid: null
	session: null
	password: null

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
				credentials.userid = response.userid
				credentials.session = response.session
				credentials.password = password

			callback(response)

sendPasswordHint = (email, callback) ->
	# Send command to server
	command.send
		cmd: "user.sendPasswordHint"
		data: email
		callback: callback

logout = ->
	# Clear values
	credentials.userid = null
	credentials.session = null
	credentials.password = null

	# Clear caches
	itemcache.clear()
	tagcache.clear()

getID = ->
	if !credentials.userid?
		throw "Error: User is not logged in"

	return credentials.userid

getSession = ->
	if !credentials.session?
		throw "Error: User is not logged in"

	return credentials.session

getPassword = ->
	if !credentials.password?
		throw "Error: User is not logged in"

	return credentials.password

module.exports.create = create
module.exports.login = login
module.exports.sendPasswordHint = sendPasswordHint
module.exports.logout = logout
module.exports.getID = getID
module.exports.getSession = getSession
module.exports.getPassword = getPassword
