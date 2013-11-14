###
# PassDeposit #

Created by Max Geissler
###

database = require "./database"

add = (item, callback) ->
	# Add timestamp
	timestamp = new Date()
	item.dateCreated = timestamp
	item.dateModified = timestamp

	database.getModel("item").create item, (err, doc) ->
		if err
			callback
				status: "db:failed"

			return
		
		# Convert mongoose document into plain javascript object
		# The ID of the newly inserted item will be included in the object
		item = doc.toClient()

		callback
			status: "success"
			item: item

modify = (item, callback) ->
	# Update timestamp
	timestamp = new Date()
	item.dateModified = timestamp

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
