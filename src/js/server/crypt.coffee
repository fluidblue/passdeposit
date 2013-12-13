###
# PassDeposit #

Created by Max Geissler
###

sjcl = require "sjcl"
crypto = require "crypto"

salt = ->
	# Generate random salt
	salt = sjcl.random.randomWords(2, 0)

	# Return base64 representation
	return sjcl.codec.base64.fromBits(salt)

session = ->
	# This function uses a modified version of the approach of
	# http://stackoverflow.com/a/14869745/2013757

	# Seed with 32 random bytes
	seed = crypto.randomBytes(32)

	# Return sha256 base64 representation
	return crypto.createHash("sha256").update(seed).digest("base64")

serverKey = (clientKey, salt) ->
	# Convert from base64 to bits
	clientKey = sjcl.codec.base64.toBits(clientKey)
	salt = sjcl.codec.base64.toBits(salt)

	# Create a server key from client key and salt:
	# PBKDF2-HMAC-SHA256 with iteration count 1000
	serverKey = sjcl.misc.pbkdf2(clientKey, salt, 1000)

	# Return base64 representation
	return sjcl.codec.base64.fromBits(serverKey) 

resetKey = ->
	# This function uses the approach of
	# http://stackoverflow.com/a/14869745/2013757

	# Seed with 20 random bytes
	seed = crypto.randomBytes(20)

	# Return sha1 hex representation
	return crypto.createHash("sha1").update(seed).digest("hex")

module.exports.salt = salt
module.exports.session = session
module.exports.serverKey = serverKey
module.exports.resetKey = resetKey
