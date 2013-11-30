###
# PassDeposit #

Created by Max Geissler
###

sjcl = require "sjcl"

salt = ->
	# Generate random salt
	return sjcl.random.randomWords(2, 0)

session = ->
	# Get random data (8 words = 32 bytes = 256 bits)
	random = sjcl.random.randomWords(8, 0)

	# Hash it
	hash = sjcl.hash.sha256.hash(random)

	# Return hex representation
	return sjcl.codec.hex.fromBits(hash)

serverKey = (clientKey, salt) ->
	# Convert clientKey from hex string to bits
	clientKey = sjcl.codec.hex.toBits(clientKey)

	# Create a server key from client key and salt:
	# PBKDF2-HMAC-SHA256 with iteration count 1000
	return sjcl.misc.pbkdf2(clientKey, salt, 1000)

module.exports.salt = salt
module.exports.session = session
module.exports.serverKey = serverKey
