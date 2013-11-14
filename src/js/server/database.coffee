###
# PassDeposit #

Created by Max Geissler
###

mongoose = require "mongoose"
log = require "./log"

models = {}

getModel = (name) ->
	return models[name]

toDBFormat = (obj) ->
	# Convert object to database format
	
	if obj.id
		obj._id = obj.id
		delete obj.id

	return obj

createModels = ->
	# Create schema for user
	userSchema = mongoose.Schema
		email: String
		password: String
		passwordHint: String
		
		created: Date
		lastActive: Date
	,
		versionKey: false

	# Create schema for field
	fieldSchema = mongoose.Schema
		type:
			type: String
		value: String
	,
		versionKey: false
		id: false
		_id: false

	# Create schema for item
	itemSchema = mongoose.Schema
		dateCreated: Date
		dateModified: Date

		encryption:
			type:
				type: String
			options: mongoose.Schema.Types.Mixed

		fields: [fieldSchema]

		tags: [Number]
	,
		versionKey: false

	# Create schema for tags
	tagsSchema = mongoose.Schema
		encryption:
			type:
				type: String
			options: mongoose.Schema.Types.Mixed

		tags: [
			key: Number
			value: String
		]
	,
		versionKey: false

	# Define toClient method used by each schema
	toClient = ->
		# Convert mongoose document into plain javascript object
		obj = this.toObject()

		# Rename id field
		if obj._id?
			obj.id = obj._id.toString()
			delete obj._id

		return obj

	compileSchema = (name, collection, schema) ->
		# Add toClient method to schema
		schema.methods.toClient = toClient

		# Compile schema to model
		# (Sets model and collection name)
		models[name] = mongoose.model(collection, schema)

	compileSchema "user", "users", userSchema
	compileSchema "item", "items", itemSchema
	compileSchema "tags", "tags", tagsSchema

init = (config, callback) ->
	# Build database connection URI:
	# mongodb://user:password@example.com/database

	databaseUri = "mongodb://"

	if config.database.user.length > 0
		databaseUri += config.database.user

		if config.database.password.length > 0
			databaseUri += ":" + config.database.password

		databaseUri += "@"

	if config.database.host.length > 0
		databaseUri += config.database.host + "/"
	else
		databaseUri += "localhost/"

	databaseUri += config.database.database

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
module.exports.toDBFormat = toDBFormat
