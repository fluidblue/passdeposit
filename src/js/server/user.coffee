###
# PassDeposit #

Created by Max Geissler
###

crypt = require "./crypt"
database = require "./database"
shared = require "./shared"
mail = require "./mail"
config = require "./config"

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

	# Prepare user data
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

reset = (email, resetKey, passwordKey, passwordHint, callback) ->
	# Validate email and passwordHint
	if !shared.validation.email(email) || !shared.validation.passwordHint(passwordHint)
		callback
			status: "input:failed"

		return

	conditions =
		key: resetKey

	database.getModel("reset").findOneAndRemove conditions, (err, doc) ->
		if err || !doc?
			callback
				status: "db:failed"

			return

		# Use a fresh random salt
		salt = crypt.salt()

		# Create server key
		serverKey = crypt.serverKey(key, salt)

		# Get current timestamp
		timestamp = new Date()

		# Check time difference
		hoursDifference = Math.abs(timestamp - doc.dateCreated) / (60 * 60 * 1000)
		if hoursDifference > 24.0
			callback
				status: "time:failed"

			return

		# Prepare user data
		user =
			password:
				key: serverKey
				salt: salt
			passwordHint: passwordHint
			
			lastActive: timestamp

			session: null

		# Update user data
		database.getModel("user").findByIdAndUpdate doc._user,
			$set: user
		, (err, doc) ->
			if err || !doc?
				callback
					status: "db:failed"

				return

			# Remove all items
			database.getModel("item").remove
				_user: doc._id
			, (err) ->
				if err
					callback
						status: "db:failed"
				else
					callback
						status: "success"

sendPasswordHint = (email, callback) ->
	# Validate email
	if !shared.validation.email(email)
		callback
			status: "failed"

		return

	conditions =
		email: email

	database.getModel("user").findOne conditions, "email passwordHint", (err, doc) ->
		if err
			callback
				status: "db:failed"

			return

		if !doc?
			# Return "success" even if no entry is found in database
			# to prevent enumerating valid email addresses
			callback
				status: "success"

			return

		conditions =
			_user: doc._id

		# Create reset key
		resetKey = crypt.resetKey()

		# Get current timestamp
		timestamp = new Date()

		# Save reset key to database
		database.getModel("reset").findOneAndUpdate conditions,
			$set:
				key: resetKey
				dateCreated: timestamp
		,
			upsert: true
		, (err, doc2) ->
			if err || !doc2?
				callback
					status: "db:failed"

				return

			# Create reset URL
			resetURL = "https://" + config.get().domain + "/reset/" + resetKey

			# Create message
			message = mail.template "passreminder",
				"%login": doc.email
				"%passwordHint": doc.passwordHint
				"%resetURL": resetURL

			# TODO: Remove
			console.log message
			callback
				status: "success"
			return

			# Send mail
			mail.send email, subject, message, (error) ->
				# Even if mail.send(...) returns no error, we can't be
				# sure that the mail has been successfully delivered.
				#
				# This doesn't bother us, because we won't return details
				# of the delivery status to prevent enumerating valid
				# email addresses.
				#
				# This means "success" only indicates that the mail has
				# been added to the mail queue. This doesn't guarantee
				# that the mail will be delivered.
				if error
					callback
						status: "mail:failed"
				else
					callback
						status: "success"

module.exports.create = create
module.exports.login = login
module.exports.authenticate = authenticate
module.exports.sendPasswordHint = sendPasswordHint
