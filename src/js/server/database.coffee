###
# PassDeposit #

Created by Max Geissler
###

mongoose = require "mongoose"
log = require "./log"
config = require "./config"

models = {}

getModel = (name) ->
	return models[name]

createModels = ->
	# Create schema for user
	userSchema = mongoose.Schema
		email:
			type: String
			unique: true

		password:
			key: String
			salt: String
		passwordHint: String
		
		created: Date
		lastActive: Date

		session: String
	,
		versionKey: false
		autoIndex: false

	# Create schema for field
	fieldSchema = mongoose.Schema
		type:
			type: String
		value: mongoose.Schema.Types.Mixed
	,
		versionKey: false
		autoIndex: false
		id: false
		_id: false

	# Create schema for item
	itemSchema = mongoose.Schema
		dateCreated: Date
		dateModified: Date

		_user:
			type: mongoose.Schema.Types.ObjectId
			index: true

		encryption:
			type:
				type: String
			options: mongoose.Schema.Types.Mixed

		fields: [fieldSchema]

		tags: [mongoose.Schema.Types.Mixed]
	,
		versionKey: false
		autoIndex: false

	# Create schema for reset
	resetSchema = mongoose.Schema
		_user:
			type: mongoose.Schema.Types.ObjectId
			unique: true

		dateCreated: Date

		key:
			type: String
			unique: true
	,
		versionKey: false
		autoIndex: false

	# Define toClient method used by each schema
	toClient = ->
		# Convert mongoose document into plain javascript object
		obj = this.toObject()

		# Rename id field
		if obj._id?
			obj.id = obj._id.toString()
			delete obj._id

		# Remove user reference
		if obj._user?
			delete obj._user

		return obj

	compileSchema = (name, collection, schema) ->
		# Add toClient method to schema
		schema.methods.toClient = toClient

		# Compile schema to model
		# (Sets model and collection name)
		models[name] = mongoose.model(collection, schema)

	compileSchema "user", "users", userSchema
	compileSchema "item", "items", itemSchema
	compileSchema "reset", "reset", resetSchema

init = (callback) ->
	# Build database connection URI:
	# mongodb://user:password@example.com/database

	databaseUri = "mongodb://"

	if config.get().database.user.length > 0
		databaseUri += config.get().database.user

		if config.get().database.password.length > 0
			databaseUri += ":" + config.get().database.password

		databaseUri += "@"

	if config.get().database.host.length > 0
		databaseUri += config.get().database.host + "/"
	else
		databaseUri += "localhost/"

	databaseUri += config.get().database.database

	# Set connection options
	options =
		server:
			poolSize: 5 # Concurrent connections to server
			auto_reconnect: true
			socketOptions:
				keepAlive: 1
		replset:
			socketOptions:
				keepAlive: 1

	# Connect
	mongoose.connect databaseUri, options, (err) ->
		if err
			log.error "Could not connect to database"
			process.exit 0

	# Set handlers
	mongoose.connection.on "error", (err) ->
		log.error "Database says: '" + err + "'"

		# TODO: Do not exit, but limit reconnecting and notifying user
		process.exit 0

	mongoose.connection.once "open", ->
		# Connected to database

		createModels()
		callback()

module.exports.init = init
module.exports.getModel = getModel
