###
# PassDeposit #

Created by Max Geissler
###

crypt = require "./crypt"

create = (email, key, passwordHint, callback) ->
	# TODO: Check email, passwordHint

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
		serverKey = serverKey(key, doc.password.salt)
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
				userid: userID

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

module.exports.create = create
module.exports.login = login
module.exports.authenticate = authenticate
