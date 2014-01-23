###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "../crypt"
shared = require "../../../shared"
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

add = (itemCrypted, callback) ->
	return _add(itemCrypted, callback, false)

_add = (itemCrypted, callback, existent) ->
	isArray = shared.util.isArray(itemCrypted)
	itemsCrypted = if isArray then itemCrypted else [itemCrypted]

	for item in itemsCrypted
		# Convert string dates to Date objects
		item.dateCreated = date(item.dateCreated)
		item.dateModified = date(item.dateModified)

	crypt.decrypt itemsCrypted, user.getPassword(), (itemsDecrypted) ->
		for i of itemsCrypted
			# Get ID
			id = itemsCrypted[i].id

			# Add to cache
			itemsEncrypted[id] = itemsCrypted[i]
			itemsDecrypted[id] = itemsDecrypted[i]

			# Update tagcache
			if existent
				tagcache.modify(id, itemsDecrypted[id].tags)
			else
				tagcache.add(id, itemsDecrypted[id].tags)

		# Return decrypted item
		if callback?
			result = if isArray then itemsDecrypted else itemsDecrypted[0]
			callback result

	return

modify = (itemCrypted, callback) ->
	return _add(itemCrypted, callback, true)

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
