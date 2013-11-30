###
# PassDeposit #

Created by Max Geissler
###

database = require "./database"
log = require "./log"

add = (item, callback) ->
	# Add timestamp
	timestamp = new Date()
	item.dateCreated = timestamp
	item.dateModified = timestamp

	database.getModel("item").create item, (err, doc) ->
		if err || !doc?
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

	database.getModel("item").findByIdAndUpdate item.id,
		$set: item
	, (err, doc) ->
		if err || !doc?
			callback
				status: "db:failed"

			return
		
		# Convert mongoose document into plain javascript object
		item = doc.toClient()

		callback
			status: "success"
			item: item

remove = (id, callback) ->
	database.getModel("item").findByIdAndRemove id, (err) ->
		if err
			callback
				status: "db:failed"

			return

		callback
			status: "success"

process = (clientID, cmd, data, callback) ->
	log.info clientID + " executes " + cmd

	invalid =
		status: "invalidcommand"

	switch cmd
		when "item.add" then add(data, callback)
		when "item.modify" then modify(data, callback)
		when "item.remove" then remove(data, callback)
		else callback(invalid)

module.exports.process = process
