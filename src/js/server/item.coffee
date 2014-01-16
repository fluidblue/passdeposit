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

	for item in items
		# Check if item is valid
		if !isItemValid(item)
			callback
				status: "input:failed"

			return

		# Add timestamp
		timestamp = new Date()
		item.dateCreated = timestamp
		item.dateModified = timestamp

		# Add userID
		item._user = userid

	database.getModel("item").create items, (err, docs...) ->
		if err || !docs? || docs.length == 0
			callback
				status: "db:failed"

			return
		
		for i of docs
			# Convert mongoose document into plain javascript object
			# The ID of the newly inserted item will be included in the object
			docs[i] = docs[i].toClient()

		callback
			status: "success"
			item: if multipleItems then docs else docs[0]

modify = (userid, item, callback) ->
	# Check if item is valid
	if !isItemValid(item)
		callback
			status: "input:failed"

		return

	# Update timestamp
	timestamp = new Date()
	item.dateModified = timestamp

	conditions =
		_id: item.id
		_user: userid

	database.getModel("item").findOneAndUpdate conditions,
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
