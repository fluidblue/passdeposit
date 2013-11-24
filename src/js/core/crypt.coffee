###
# PassDeposit #
Cryptographic module

Created by Max Geissler
###

defaultEncryption =
	type: "aes256"
	options:
		param0: 0
		param1: 1

encrypt = (item, encryption = defaultEncryption) ->
	# TODO

	# Add encryption info to item
	item.encryption = encryption

	return item

decrypt = (item) ->
	# TODO

	return item

module.exports.encrypt = encrypt
module.exports.decrypt = decrypt
