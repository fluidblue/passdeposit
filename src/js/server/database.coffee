###
# PassDeposit #

Created by Max Geissler
###

mongojs = require "mongojs"

db = null

mongo2id = (item) ->
	# Convert MongoDB ObjectID to id string
	item.id = item._id.toString()
	delete item._id

	return item

id2mongo = (item) ->
	# Convert id string to MongoDB ObjectID
	item._id = mongojs.ObjectId(item.id)
	delete item.id

	return item

get = ->
	return db

init = (config) ->
	# Build database connection URI:
	# user:password@example.com/database

	databaseUri = ""

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

	# Collections
	collections = ["users"]

	# Connect
	db = mongojs.connect(databaseUri, collections)

module.exports.init = init
module.exports.get = get
module.exports.mongo2id = mongo2id
module.exports.id2mongo = id2mongo
