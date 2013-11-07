###
# PassDeposit #

Created by Max Geissler
###

mongojs = require "mongojs"

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
	collections = ["users", "reports"]

	# Connect
	db = mongojs.connect(databaseUri, collections)

module.exports.init = init
