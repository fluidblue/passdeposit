###
# PassDeposit #
Cryptographic module

Created by Max Geissler
###

sjcl = require "sjcl"
user = require "./user"
clone = require "./clone"

# Define encryptions
availableEncryptions =
	none:
		type: "none"
		options: null
	
	aes256:
		type: "sjcl"
		options:
			v: 1
			iter: 1000
			ks: 256
			ts: 128
			mode: "ccm"
			adata: ""
			cipher: "aes"

# Default encryption
defaultEncryption = availableEncryptions.aes256

encrypt = (item, encryption = defaultEncryption) ->
	password = user.getPassword()
	fnEncrypt = null

	# Define encryption function
	switch encryption.type
		when "none"
			fnEncrypt = (str) ->
				return str
		when "sjcl"
			fnEncrypt = (str) ->
				# Always use a fresh random salt (8 Bytes)
				salt = sjcl.random.randomWords(2, 0)

				# Create the key from password and salt:
				# PBKDF2-HMAC-SHA256 with given iteration count
				key = sjcl.misc.pbkdf2(password, salt, encryption.options.iter)

				# Shorten key to encryption keysize length
				key = key.slice(0, encryption.options.ks / 32)

				# Encrypt with SJCL
				enc = sjcl.json._encrypt(key, str, encryption.options)

				# Return only relevant information
				ret =
					iv: sjcl.codec.base64.fromBits(enc.iv)
					salt: sjcl.codec.base64.fromBits(salt)
					ct: sjcl.codec.base64.fromBits(enc.ct)

				return ret
		else
			throw "Error: Unknown encryption: " + encryption.type

	# Make a deep copy of the item
	item = clone.deepCopy(item)

	# Encrypt fields
	for key, entry of item.fields
		item.fields[key].value = fnEncrypt(entry.value)

	# Encrypt tags
	for key, value of item.tags
		item.tags[key] = fnEncrypt(value)

	# Add encryption info to item
	item.encryption = encryption

	return item

decrypt = (item) ->
	password = user.getPassword()
	fnDecrypt = null

	# Define decryption function
	switch item.encryption.type
		when "none"
			fnDecrypt = (value) ->
				return value
		when "sjcl"
			fnDecrypt = (value) ->
				# Create raw ciphertext object from value
				crypt =
					iv: sjcl.codec.base64.toBits(value.iv)
					salt: sjcl.codec.base64.toBits(value.salt)
					ct: sjcl.codec.base64.toBits(value.ct)

				# Decrypt with SJCL lib
				return sjcl.json._decrypt(password, item.encryption.options, crypt)
		else
			throw "Error: Unknown encryption: " + item.encryption.type

	# Make a deep copy of the item
	item = clone.deepCopy(item)

	# Decrypt fields
	for key, entry of item.fields
		item.fields[key].value = fnDecrypt(entry.value)

	# Decrypt tags
	for key, value of item.tags
		item.tags[key] = fnDecrypt(value)

	return item

format = (encryption) ->
	# Output default encryption if no encryption is given
	if !encryption?
		encryption = defaultEncryption

	return switch encryption.type
		when "none" then "None"
		when "sjcl" then encryption.options.cipher.toUpperCase() + " " + encryption.options.ks
		else encryption.type

key = (password, salt) ->
	# Create key from password and salt:
	# PBKDF2-HMAC-SHA256 with iteration count 1000
	key = sjcl.misc.pbkdf2(password, salt, 1000)
	return sjcl.codec.base64.fromBits(key)

module.exports.encrypt = encrypt
module.exports.decrypt = decrypt
module.exports.format = format
module.exports.key = key
module.exports.availableEncryptions = availableEncryptions
