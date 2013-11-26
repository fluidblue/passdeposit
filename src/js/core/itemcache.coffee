###
# PassDeposit #
Item cache

Created by Max Geissler
###

# TODO: Remove
testItems = require "./testfields.json"
crypt = require "./crypt"

itemsEncrypted = {}
itemsDecrypted = {}

get = (id = undefined) ->
	if id?
		return itemsDecrypted[id]
	else
		return itemsDecrypted

load = ->
	# TODO: Load from DB
	for item in testItems
		itemsEncrypted[item.id] = item
		itemsDecrypted[item.id] = crypt.decrypt(item)

module.exports.load = load
module.exports.get = get
