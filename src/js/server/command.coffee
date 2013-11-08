###
# PassDeposit #

Created by Max Geissler
###

database = require "./database"

add = (item, callback) ->
	# Add timestamp
	timestamp = Date.now()
	item.dateCreated = timestamp
	item.dateModified = timestamp

	database.get().users.insert item, (err, saved) ->
		if err || !saved
			callback
				status: "db:failed"

			return
		
		# The id of the inserted item is saved to item._id
		# Convert item._id to item.id
		database.mongo2id(item)

		callback
			status: "success"
			item: item

modify = (item, callback) ->
	# TODO
	item.dateCreated = 0
	item.dateModified = 0
	item.encryption =
		type: "aes256"
		param0: 0
		param1: 1

	callback
		status: "success"
		item: item

remove = (id, callback) ->
	# TODO

	callback
		status: "success"

process = (cmd, data, callback) ->
	invalid =
		status: "invalidcommand"

	switch cmd
		when "add" then add(data, callback)
		when "modify" then modify(data, callback)
		when "remove" then remove(data, callback)
		else callback(invalid)

module.exports.process = process
