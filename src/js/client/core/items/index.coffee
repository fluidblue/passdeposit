###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "../command"
crypt = require "../crypt"
user = require "../user"
itemcache = require "./itemcache"
tagcache = require "./tagcache"
search = require "./search"

add = (item, callback) ->
	# Encrypt
	crypt.encrypt item, user.getPassword(), (item) ->
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
					itemcache.add item, (items) ->
						callback(response)
				else
					callback(response)

addBulk = (items, callback) ->
	# Encrypt
	crypt.encrypt items, user.getPassword(), (items) ->
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
					itemcache.add items, (items) ->
						callback(response)
				else
					callback(response)

modify = (item, callback) ->
	# Encrypt
	crypt.encrypt item, user.getPassword(), (item) ->
		# Send command to server
		command.send
			cmd: "item.modify"
			data: item
			authenticate: true
			callback: (response) ->
				if response.status == "success"
					# Set date
					item.dateCreated = itemcache.get(item.id).dateCreated
					item.dateModified = response.dateModified

					# Update item cache
					itemcache.modify item, (items) ->
						callback(response)
				else
					callback(response)

modifyBulk = (items, callback) ->
	# Encrypt
	crypt.encrypt items, user.getPassword(), (items) ->
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
						itemcache.modify item, (items) ->
							callback(response)
				else
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
				# Update item cache
				itemcache.add response.items, (items) ->
					callback(response)
			else
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
module.exports.getArray = itemcache.getArray
module.exports.clear = clear
module.exports.load = load
module.exports.getTagArray = tagcache.getArray
module.exports.updateEncryptedItems = itemcache.updateEncryptedItems
