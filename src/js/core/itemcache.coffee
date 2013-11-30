###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "./crypt"
command = require "./command"

itemsEncrypted = {}
itemsDecrypted = {}

get = (id = undefined) ->
	if id?
		return itemsDecrypted[id]
	else
		return itemsDecrypted

load = (callback) ->
	# Get all items from server
	command.send
		cmd: "item.get"
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				for item in response.items
					# Update item cache
					add(item)

					# Update tagcache
					tagcache.add(item.id, item.tags)

				callback(true)
			else
				console.log "Error: Loading items failed: " + response.status
				callback(false)

add = (itemCrypted) ->
	itemsEncrypted[itemCrypted.id] = itemCrypted
	itemsDecrypted[itemCrypted.id] = crypt.decrypt(itemCrypted)

	# Return decrypted item
	return itemsDecrypted[itemCrypted.id]

modify = (itemCrypted) ->
	# Exactly the same as adding
	return add(itemCrypted)

remove = (id) ->
	delete itemsEncrypted[id]
	delete itemsDecrypted[id]

	return true

module.exports.get = get
module.exports.load = load
module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
