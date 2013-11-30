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

get = ->
	# TODO
	return

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = get
