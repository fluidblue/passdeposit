###
# PassDeposit #

Created by Max Geissler
###

crypto = require "crypto"

# Iterations for PBKDF2
# Takes ~500ms
pbkdf2iterations = 300000

salt = ->
	# Generate random salt (8 Bytes)
	buf = crypto.randomBytes(8)

	# Return base64 representation
	return buf.toString("base64")

session = ->
	# This function uses a modified version of the approach of
	# http://stackoverflow.com/a/14869745/2013757

	# Seed with 32 random bytes
	seed = crypto.randomBytes(32)

	# Return sha256 base64 representation
	return crypto.createHash("sha256").update(seed).digest("base64")

serverKey = (clientKey, salt, callback) ->
	# Convert from base64 to binary
	clientKey = new Buffer(clientKey, "base64")
	salt = new Buffer(salt, "base64")

	# Create a server key from client key and salt:
	# PBKDF2-HMAC-SHA1 with given iteration count and keylen 160/8 (length of SHA1)
	serverKey = crypto.pbkdf2 clientKey, salt, pbkdf2iterations, 160/8, (err, derivedKey) ->
		if err
			callback err, null
		else
			# Return base64 representation
			callback null, derivedKey.toString("base64")

	# Return undefined to prevent misuse of function
	return

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
