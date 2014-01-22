###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "../crypt"
user = require "../user"
tagcache = require "./tagcache"
date = require "./date"

itemsEncrypted = {}
itemsDecrypted = {}

get = (id = undefined) ->
	if id?
		return itemsDecrypted[id]
	else
		return itemsDecrypted

getArray = () ->
	items = []

	for id, item of itemsDecrypted
		items.push item

	return items

add = (itemCrypted, callback, existent = false) ->
	# Convert string dates to Date objects
	itemCrypted.dateCreated = date(itemCrypted.dateCreated)
	itemCrypted.dateModified = date(itemCrypted.dateModified)

	crypt.decrypt itemCrypted, user.getPassword(), (itemDecrypted) ->
		# Add to cache
		itemsEncrypted[itemCrypted.id] = itemCrypted
		itemsDecrypted[itemCrypted.id] = itemDecrypted

		# Update tagcache
		if existent
			tagcache.modify(itemCrypted.id, itemsDecrypted[itemCrypted.id].tags)
		else
			tagcache.add(itemCrypted.id, itemsDecrypted[itemCrypted.id].tags)

		# Return decrypted item
		if callback?
			callback itemsDecrypted[itemCrypted.id]

	return

modify = (itemCrypted, callback) ->
	return add(itemCrypted, callback, true)

remove = (id) ->
	delete itemsEncrypted[id]
	delete itemsDecrypted[id]

	# Update tagcache
	tagcache.remove(id)

	return true

clear = ->
	itemsEncrypted = {}
	itemsDecrypted = {}

module.exports.get = get
module.exports.getArray = getArray
module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.clear = clear
