###
# PassDeposit #
User management module

Created by Max Geissler
###

crypt = require "./crypt"
command = require "./command"
items = require "./items"

# User's email, user's ID, current session and plaintext master password
# These values are only set if the user is logged in.
credentials =
	email: null
	userid: null
	session: null
	password: null

create = (email, password, passwordHint, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	crypt.key password, email, (key) ->
		# Send command to server
		command.send
			cmd: "user.create"
			data:
				email: email
				key: key
				passwordHint: passwordHint
			callback: callback

updateEmail = (email, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	crypt.key credentials.password, email, (key) ->
		# Send command to server
		command.send
			cmd: "user.update"
			data:
				email: email
				key: key
			authenticate: true
			callback:  (response) ->
				if response.status == "success"
					# Save email
					credentials.email = email

				callback(response)

updatePassword = (password, passwordHint, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	crypt.key password, credentials.email, (key) ->
		# Get all items
		itemArray = items.getArray()

		# Re-encrypt all items with new password
		crypt.encrypt itemArray, password, (itemArray) ->
			# Send command to server
			command.send
				cmd: "user.update"
				data:
					key: key
					passwordHint: passwordHint
					items: itemArray
				authenticate: true
				callback:  (response) ->
					if response.status == "success"
						# Save password
						credentials.password = password

						# Update cache
						items.updateEncryptedItems(itemArray)

					callback(response)

reset = (resetKey, email, password, passwordHint, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	crypt.key password, email, (passwordKey) ->
		# Send command to server
		command.send
			cmd: "user.reset"
			data:
				resetKey: resetKey
				email: email
				passwordKey: passwordKey
				passwordHint: passwordHint
			callback: callback

login = (email, password, callback) ->
	# Create key from password and email address as salt.
	# This key is salted and hashed again on the server, using a random salt.
	crypt.key password, email, (key) ->
		# Send command to server
		command.send
			cmd: "user.login"
			data:
				email: email
				key: key
			callback: (response) ->
				if response.status == "success"
					# Save userID and session
					credentials.email = email
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
	credentials.email = null
	credentials.userid = null
	credentials.session = null
	credentials.password = null

	# Clear all items
	items.clear()

isLoggedIn = ->
	return credentials.session?

getEmail = ->
	if !credentials.email?
		throw "Error: User is not logged in"

	return credentials.email

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
module.exports.updateEmail = updateEmail
module.exports.updatePassword = updatePassword
module.exports.reset = reset
module.exports.login = login
module.exports.sendPasswordHint = sendPasswordHint
module.exports.logout = logout
module.exports.isLoggedIn = isLoggedIn
module.exports.getEmail = getEmail
module.exports.getID = getID
module.exports.getSession = getSession
module.exports.getPassword = getPassword
