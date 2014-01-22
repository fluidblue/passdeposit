###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "../command"
crypt = require "../crypt"
itemcache = require "./itemcache"
tagcache = require "./tagcache"
search = require "./search"

add = (item, callback) ->
	# Encrypt
	item = crypt.encrypt(item)

	# Send command to server
	command.send
		cmd: "item.add"
		data: item
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Set ID
				item.id = response.id

				# Set date
				item.dateCreated = response.dateCreated
				item.dateModified = response.dateCreated

				# Update item cache
				itemcache.add(item)

			callback(response)

addBulk = (items, callback) ->
	# Encrypt
	for i of items
		items[i] = crypt.encrypt(items[i])

	# Send command to server
	command.send
		cmd: "item.add"
		data: items
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				for i, item of items
					# Set ID
					item.id = response.id[i]

					# Set date
					item.dateCreated = response.dateCreated
					item.dateModified = response.dateCreated

					# Update item cache
					itemcache.add(item)

			callback(response)

modify = (item, callback) ->
	# Encrypt
	item = crypt.encrypt(item)
	
	# Send command to server
	command.send
		cmd: "item.modify"
		data: item
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Set date
				item.dateModified = response.dateModified

				# Update item cache
				itemcache.modify(item)

			callback(response)

modifyBulk = (items, callback) ->
	# Encrypt
	for i of items
		items[i] = crypt.encrypt(items[i])
	
	# Send command to server
	command.send
		cmd: "item.modify"
		data: items
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				for i, item of items
					# Set date
					item.dateModified = response.dateModified

					# Update item cache
					itemcache.modify(item)

			callback(response)

remove = (id, callback) ->
	# Send command to server
	command.send
		cmd: "item.remove"
		data: id
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.remove(id)

			callback(response)

load = (callback) ->
	# Get all items from server
	command.send
		cmd: "item.get"
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				for item in response.items
					# Update item cache
					itemcache.add(item)
			
			callback(response)

clear = ->
	# Clear caches
	itemcache.clear()
	tagcache.clear()

module.exports.search = search
module.exports.add = add
module.exports.addBulk = addBulk
module.exports.modify = modify
module.exports.modifyBulk = modifyBulk
module.exports.remove = remove
module.exports.get = itemcache.get
module.exports.clear = clear
module.exports.load = load
module.exports.getTagArray = tagcache.getArray
