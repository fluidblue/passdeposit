###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

command = require "./command"
taglist = require "./taglist"
crypt = require "./crypt"
itemcache = require "./itemcache"

add = (item, callback) ->
	# Encrypt
	item = crypt.encrypt(item)

	# Send command to server
	command.send
		cmd: "add"
		data: item
		callback: (response) ->
			if response.status == "success"
				# TODO: Update item cache

				# Update taglist
				taglist.add(response.item.id, response.item.tags)

			callback(response)

modify = (item, callback) ->
	# Encrypt
	item = crypt.encrypt(item)
	
	# Send command to server
	command.send
		cmd: "modify"
		data: item
		callback: (response) ->
			if response.status == "success"
				# TODO: Update item cache

				# Update taglist
				taglist.modify(response.item.id, response.item.tags)

			callback(response)

remove = (id, callback) ->
	# Send command to server
	command.send
		cmd: "remove"
		data: id
		callback: (response) ->
			if response.status == "success"
				# TODO: Update item cache

				# Update taglist
				taglist.remove(id)

			callback(response)

module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = itemcache.get
module.exports.load = itemcache.load
