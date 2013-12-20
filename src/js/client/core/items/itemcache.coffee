###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "../crypt"
tagcache = require "./tagcache"

itemsEncrypted = {}
itemsDecrypted = {}

get = (id = undefined) ->
	if id?
		return itemsDecrypted[id]
	else
		return itemsDecrypted

add = (itemCrypted) ->
	itemsEncrypted[itemCrypted.id] = itemCrypted
	itemsDecrypted[itemCrypted.id] = crypt.decrypt(itemCrypted)

	# Update tagcache
	tagcache.add(itemCrypted.id, itemsDecrypted[itemCrypted.id].tags)

	# Return decrypted item
	return itemsDecrypted[itemCrypted.id]

modify = (itemCrypted) ->
	# Exactly the same as adding
	itemDecrypted = add(itemCrypted)

	# Update tagcache
	tagcache.modify(itemCrypted.id, itemDecrypted.tags)

	# Return decrypted item
	return itemDecrypted

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
