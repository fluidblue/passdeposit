###
# PassDeposit #

Created by Max Geissler
###

crypt = require "./crypt"
database = require "./database"
shared = require "./shared"
mail = require "./mail"

create = (email, key, passwordHint, callback) ->
	# Validate email and passwordHint
	if !shared.validation.email(email) || !shared.validation.passwordHint(passwordHint)
		callback
			status: "input:failed"

		return

	# Use a fresh random salt
	salt = crypt.salt()

	# Create server key
	serverKey = crypt.serverKey(key, salt)

	# Get current timestamp
	timestamp = new Date()

	# Create user object
	user =
		email: email
		password:
			key: serverKey
			salt: salt
		passwordHint: passwordHint
		
		created: timestamp
		lastActive: timestamp

		session: null

	database.getModel("user").create user, (err, doc) ->
		if err || !doc?
			# Check for duplicate key error
			if err.code == 11000
				callback
					status: "db:duplicate"
			else
				callback
					status: "db:failed"

			return

		callback
			status: "success"

login = (email, key, callback) ->
	userModel = database.getModel("user")

	conditions =
		email: email

	userModel.findOne conditions, "password", (err, doc) ->
		if err || !doc?
			callback
				status: "db:failed"

			return

		# Authenticate user
		serverKey = crypt.serverKey(key, doc.password.salt)
		if serverKey != doc.password.key
			callback
				status: "auth:failed"

			return

		# Create session
		session = crypt.session()

		# Get current timestamp
		timestamp = new Date()

		# Get ID
		userID = doc._id

		# Save session
		userModel.findByIdAndUpdate userID,
			$set:
				session: session
				lastActive: timestamp
		, (err, doc) ->
			if err || !doc?
				callback
					status: "db:failed"

				return

			callback
				status: "success"
				session: session
				userid: userID.toString()

authenticate = (userid, session, callback) ->
	if !userid? || !session?
		callback(false)
		return

	conditions =
		_id: userid
		session: session

	database.getModel("user").count conditions, (err, count) ->
		authenticated = !err && count == 1
		callback(authenticated)

sendPasswordHint = (email, callback) ->
	# Validate email
	if !shared.validation.email(email)
		callback
			status: "input:failed"

		return

	# TODO
	mail.send email, "Subject", "Message", (success) ->
		callback
			status: "failed"

module.exports.create = create
module.exports.login = login
module.exports.authenticate = authenticate
module.exports.sendPasswordHint = sendPasswordHint
