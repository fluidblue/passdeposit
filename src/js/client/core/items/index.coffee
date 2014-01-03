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
	itemCrypted = crypt.encrypt(item)

	# Send command to server
	command.send
		cmd: "item.add"
		data: itemCrypted
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.add(response.item)

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
				for item in response.items
					# Update item cache
					itemcache.add(item)

			callback(response)

modify = (item, callback) ->
	# Encrypt
	itemCrypted = crypt.encrypt(item)
	
	# Send command to server
	command.send
		cmd: "item.modify"
		data: itemCrypted
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.modify(response.item)

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
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = itemcache.get
module.exports.clear = clear
module.exports.load = load
module.exports.getTagArray = tagcache.getArray
