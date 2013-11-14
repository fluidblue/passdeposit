###
# PassDeposit #

Created by Max Geissler
###

mongoose = require "mongoose"

models = {}

getModel = (name) ->
	return models[name]

# TODO: Rename, remove(?)
id2mongo = (item) ->
	# Convert id string to MongoDB ObjectID
	if item.id
		item._id = mongoose.Schema.ObjectId(item.id)
		delete item.id

	return item

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

	# Connect
	mongoose.connect(databaseUri)

	# Set handlers
	mongoose.connection.on "error", (err) ->
		# The database is down
		console.log "Error: Could not connect to database"

	mongoose.connection.once "open", ->
		# Connected to database

		createModels()
		callback()

module.exports.init = init
module.exports.getModel = getModel
module.exports.id2mongo = id2mongo
