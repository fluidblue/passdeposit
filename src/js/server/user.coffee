###
# PassDeposit #

Created by Max Geissler
###

crypt = require "./crypt"
database = require "./database"
shared = require "./shared"
mail = require "./mail"
config = require "./config"
log = require "./log"
item = require "./item"
shared = require "./shared"

features = (callback) ->
	callback
		status: "success"
		registration: config.get().registrationEnabled

create = (email, key, passwordHint, callback) ->
	# Check if registration is enabled on the server
	if !config.get().registrationEnabled
		callback
			status: "invalidcommand"

		return

	# Validate email and passwordHint
	if !shared.validation.email(email) || !shared.validation.passwordHint(passwordHint)
		callback
			status: "input:failed"

		return

	# Use a fresh random salt
	salt = crypt.salt()

	# Create server key
	crypt.serverKey key, salt, (err, serverKey) ->
		if err
			log.error "Failed to compute serverKey: " + log.errmsg(err)

			callback
				status: "crypt:failed"

			return

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
				if err.code == 11000 || err.code == 11001
					callback
						status: "db:duplicate"
				else
					callback
						status: "db:failed"

				return

			callback
				status: "success"

update = (userid, data, callback) ->
	# Validate input data
	valid = true

	if data.email?
		if !shared.validation.email(data.email) || !data.key?
			valid = false
	else if data.key?
		if !data.passwordHint? || !shared.validation.passwordHint(data.passwordHint) || !shared.util.isArray(data.items)
			valid = false
	else
		valid = false

	if !valid
		callback
			status: "input:failed"

		return

	# Prepare user data
	user = {}

	# Update email
	if data.email?
		user.email = data.email

	# Save passwordHint
	if data.passwordHint?
		user.passwordHint = data.passwordHint

	# Use a fresh random salt
	salt = crypt.salt()

	# Create server key
	crypt.serverKey data.key, salt, (err, serverKey) ->
		if err
			log.error "Failed to compute serverKey: " + log.errmsg(err)

			callback
				status: "crypt:failed"

			return

		# Update user's password
		savepassword = ->
			# Set password (serverKey and salt)
			user.password =
				key: serverKey
				salt: salt

			# Write to DB
			database.getModel("user").update
				_id: userid
			,
				$set: user
			, (err, raw) ->
				if err || !raw? || raw.ok != 1 || raw.n != 1
					# Check for duplicate key error
					if err.code == 11000 || err.code == 11001
						callback
							status: "db:duplicate"
					else
						callback
							status: "db:failed"

					return

				callback
					status: "success"

		# Update items
		if data.items? && data.items.length > 0
			item.modify userid, data.items, (response) ->
				# Cancel on error
				if response.status != "success"
					callback response
					return

				savepassword()
			, false
		else
			savepassword()

login = (email, key, callback) ->
	userModel = database.getModel("user")

	conditions =
		email: email

	userModel.findOne conditions, "password", (err, doc) ->
		if err
			callback
				status: "db:failed"

			return

		if !doc?
			callback
				status: "auth:failed"

			return

		# Authenticate user
		crypt.serverKey key, doc.password.salt, (err, serverKey) ->
			if err
				log.error "Failed to compute serverKey: " + log.errmsg(err)

				callback
					status: "auth:failed"

				return

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
			,
				new: true
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

	database.getModel("user").findById userid, (err, doc) ->
		if err
			callback
				status: "db:failed"

			return

		timestamp = new Date()

		if !doc? || doc.session != session || (timestamp.getTime() - doc.lastActive.getTime()) > 15 * 60 * 1000
			callback
				status: "auth:failed"

			return

		# Update lastActive timestamp
		database.getModel("user").update
			_id: userid
		,
			$set:
				lastActive: timestamp
		, (err, raw) ->
			if err || !raw? || raw.ok != 1 || raw.n != 1
				callback
					status: "db:failed"

				return

			callback
				status: "success"

reset = (resetKey, email, passwordKey, passwordHint, callback) ->
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
		crypt.serverKey passwordKey, salt, (err, serverKey) ->
			if err
				log.error "Failed to compute serverKey: " + log.errmsg(err)

				callback
					status: "crypt:failed"

				return

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
			,
				new: true
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
			new: true
		, (err, doc2) ->
			if err || !doc2?
				callback
					status: "db:failed"

				return

			# Create reset URL
			protocol = if config.get().https.enabled then "https" else "http"
			resetURL = protocol + "://" + config.get().domain + "/reset-" + doc.email + "-" + resetKey

			# Create message
			message = mail.template "passreminder",
				"%login": doc.email
				"%passwordHint": doc.passwordHint
				"%resetURL": resetURL

			# Send mail
			mail.send doc.email, message.subject, message.text, (error) ->
				# Even if mail.send(...) returns no error, we can't be
				# sure that the mail has been successfully delivered.
				#
				# This doesn't bother us, because we won't return details
				# of the delivery status to prevent enumerating registered
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

module.exports.features = features
module.exports.create = create
module.exports.update = update
module.exports.reset = reset
module.exports.login = login
module.exports.authenticate = authenticate
module.exports.sendPasswordHint = sendPasswordHint
