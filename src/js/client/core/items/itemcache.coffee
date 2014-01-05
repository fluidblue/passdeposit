###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "../crypt"
tagcache = require "./tagcache"
date = require "./date"

itemsEncrypted = {}
itemsDecrypted = {}

get = (id = undefined) ->
	if id?
		return itemsDecrypted[id]
	else
		return itemsDecrypted

add = (itemCrypted, existent = false) ->
	# Convert string dates to Date objects
	itemCrypted.dateCreated = date(itemCrypted.dateCreated)
	itemCrypted.dateModified = date(itemCrypted.dateModified)

	# Add to cache
	itemsEncrypted[itemCrypted.id] = itemCrypted
	itemsDecrypted[itemCrypted.id] = crypt.decrypt(itemCrypted)

	# Update tagcache
	if existent
		tagcache.modify(itemCrypted.id, itemsDecrypted[itemCrypted.id].tags)
	else
		tagcache.add(itemCrypted.id, itemsDecrypted[itemCrypted.id].tags)

	# Return decrypted item
	return itemsDecrypted[itemCrypted.id]

modify = (itemCrypted) ->
	return add(itemCrypted, true)

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
module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.clear = clear
