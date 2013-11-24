###
# PassDeposit #
Cryptographic module

Created by Max Geissler
###

sjcl = require "sjcl"

# Default encryption
defaultEncryption =
	type: "aes256"
	options:
		ks: 256
		ts: 128
		mode: "ccm"
		cipher: "aes"

# Holds the master password
password = null

encrypt = (item, encryption = defaultEncryption) ->
	# Cancel if master password is unknown
	if !password?
		return null

	# TODO
	#enc = sjcl.encrypt(password, item.xxx, encryption.options)

	# Add encryption info to item
	item.encryption = encryption

	return item

decrypt = (item) ->
	# TODO

	return item

module.exports.encrypt = encrypt
module.exports.decrypt = decrypt
