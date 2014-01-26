###
# PassDeposit #
WebWorker cryptographic module

Created by Max Geissler
###

sjcl = require "sjcl"

initialized = false

encrypt = (items, password, encryption) ->
	for i of items
		item = items[i]
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

		# Encrypt fields
		for key, entry of item.fields
			item.fields[key].value = fnEncrypt(entry.value)

		# Encrypt tags
		for key, value of item.tags
			item.tags[key] = fnEncrypt(value)

		# Add encryption info to item
		item.encryption = encryption

		items[i] = item

	return items

decrypt = (items, password) ->
	for i of items
		item = items[i]
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

		# Decrypt fields
		for key, entry of item.fields
			item.fields[key].value = fnDecrypt(entry.value)

		# Decrypt tags
		for key, value of item.tags
			item.tags[key] = fnDecrypt(value)

		items[i] = item

	return items

key = (password, salt, iterations) ->
	# Create key from password and salt:
	# PBKDF2-HMAC-SHA256 with given iteration count
	key = sjcl.misc.pbkdf2(password, salt, iterations)
	return sjcl.codec.base64.fromBits(key)

addEntropy = (buf) ->
	sjcl.random.addEntropy(buf, 1024, "crypto.getRandomValues")
	return true

module.exports.encrypt = encrypt
module.exports.decrypt = decrypt
module.exports.key = key
module.exports.addEntropy = addEntropy
