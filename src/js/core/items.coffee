###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"
tagcache = require "./tagcache"
crypt = require "./crypt"
itemcache = require "./itemcache"

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

				# Update tagcache
				tagcache.add(response.item.id, response.item.tags)

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

				# Update tagcache
				tagcache.modify(response.item.id, response.item.tags)

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
				itemcache.remove(response.item.id)

				# Update tagcache
				tagcache.remove(id)

			callback(response)

load = ->
	itemcache.load()
	tagcache.create()

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = itemcache.get
module.exports.load = load
