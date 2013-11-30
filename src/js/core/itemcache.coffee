###
# PassDeposit #
Item cache

Created by Max Geissler
###

crypt = require "./crypt"

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
module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
