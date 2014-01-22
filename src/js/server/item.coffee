###
# PassDeposit #

Created by Max Geissler
###

database = require "./database"

isArray = (obj) ->
	return Object::toString.call(obj) == "[object Array]"

isItemValid = (item) ->
	return item && item.encryption? && item.encryption.type? &&
		isArray(item.tags) && isArray(item.fields) &&
		item.fields.length > 0

add = (userid, items, callback) ->
	multipleItems = isArray(items)

	# If single item is given, make array
	if !multipleItems
		items = [items]

	# Check if at least one item is given
	if items.length <= 0
		callback
			status: "input:failed"

		return

	# Create timestamp
	timestamp = new Date()

	for item in items
		# Check if item is valid
		if !isItemValid(item)
			callback
				status: "input:failed"

			return

		# Add timestamp
		item.dateCreated = timestamp
		item.dateModified = timestamp

		# Add userID
		item._user = userid

	database.getModel("item").create items, (err, docs...) ->
		if err || !docs? || docs.length == 0
			callback
				status: "db:failed"

			return

		# Create list with IDs of the newly inserted items
		idList = []
		for i of docs
			idList.push docs[i]._id

		callback
			status: "success"
			dateCreated: timestamp
			id: if multipleItems then idList else idList[0]

modify = (userid, items, callback) ->
	multipleItems = isArray(items)

	# If single item is given, make array
	if !multipleItems
		items = [items]

	# Check if at least one item is given
	if items.length <= 0
		callback
			status: "input:failed"

		return

	# Create timestamp
	timestamp = new Date()

	for item in items
		# Check if item is valid
		if !isItemValid(item) || !item.id?
			callback
				status: "input:failed"

			return

		# Update timestamp
		item.dateModified = timestamp

	# TODO: If anything goes wrong, restore old state.
	# Ideas: Create new user / Use backup items

	# Unfortunately, mongoose doesn't allow updating
	# multiple documents, like in model.create(...).
	# Therefore we must loop by ourselves through the array.
	next = ->
		# Get next item
		item = items.pop()

		# Query conditions
		conditions =
			_id: item.id
			_user: userid

		# Update item in DB
		database.getModel("item").update conditions,
			$set: item
		, (err, numberAffected, raw) ->
			if err || !numberAffected? || numberAffected != 1
				callback
					status: "db:failed"

				return

			if items.length > 0
				# Proceed with next item
				next()
			else
				# Finished
				callback
					status: "success"
					dateModified: timestamp

	# Start loop
	next()

remove = (userid, id, callback) ->
	conditions =
		_id: id
		_user: userid

	database.getModel("item").remove conditions, (err) ->
		if err
			callback
				status: "db:failed"

			return

		callback
			status: "success"

get = (userid, callback) ->
	conditions =
		_user: userid

	database.getModel("item").find conditions, (err, docs) ->
		if err || !docs?
			callback
				status: "db:failed"

			return

		# Convert mongoose documents into plain javascript objects
		for key, doc of docs
			docs[key] = docs[key].toClient()

		callback
			status: "success"
			items: docs

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = get
