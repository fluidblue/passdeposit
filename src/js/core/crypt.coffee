###
# PassDeposit #
Cryptographic module

Created by Max Geissler
###

sjcl = require "sjcl"

# Define encryptions
availableEncryptions =
	none:
		type: "none"
		options: null
	
	sjcl:
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
defaultEncryption = availableEncryptions.sjcl

# Holds the master password
password = null

encrypt = (item, encryption = defaultEncryption) ->
	# TODO: Remove
	password = "pass"

	# Cancel if master password is unknown
	if !password?
		console.log "Error: Master password unknown"
		return null

	fnEncrypt = null

	# Define encryption function
	switch encryption.type
		when "sjcl"
			fnEncrypt = (str) ->
				# Encrypt with SJCL lib
				enc = sjcl.encrypt(password, str, encryption.options)

				# Parse JSON to get object
				obj = JSON.parse(enc)

				# Return only relevant information
				ret =
					iv: obj.iv
					salt: obj.salt
					ct: obj.ct

				return ret
		else
			console.log "Error: Unknown encryption: " + encryption.type
			return null

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
	# Cancel if master password is unknown
	if !password?
		return null

	# TODO

	return item

format = (encryption) ->
	# Output default encryption if no encryption is given
	if !encryption?
		encryption = defaultEncryption

	return switch encryption.type
		when "none" then "None"
		when "sjcl" then encryption.options.cipher.toUpperCase() + " " + encryption.options.ks
		else encryption.type

module.exports.encrypt = encrypt
module.exports.decrypt = decrypt
module.exports.format = format
