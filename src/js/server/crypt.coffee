###
# PassDeposit #

Created by Max Geissler
###

sjcl = require "sjcl"

salt = ->
	# Generate random salt
	salt = sjcl.random.randomWords(2, 0)

	# Return base64 representation
	return sjcl.codec.base64.fromBits(salt)

session = ->
	# Get random data (8 words = 32 bytes = 256 bits)
	random = sjcl.random.randomWords(8, 0)

	# Hash it
	hash = sjcl.hash.sha256.hash(random)

	# Return base64 representation
	return sjcl.codec.base64.fromBits(hash)

serverKey = (clientKey, salt) ->
	# Convert from base64 to bits
	clientKey = sjcl.codec.base64.toBits(clientKey)
	salt = sjcl.codec.base64.toBits(salt)

	# Create a server key from client key and salt:
	# PBKDF2-HMAC-SHA256 with iteration count 1000
	serverKey = sjcl.misc.pbkdf2(clientKey, salt, 1000)

	# Return base64 representation
	return sjcl.codec.base64.fromBits(serverKey) 

module.exports.salt = salt
module.exports.session = session
module.exports.serverKey = serverKey
