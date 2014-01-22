###
# PassDeposit #
Cryptographic module

Created by Max Geissler
###

worker = require "./worker"
shared = require "../../shared"

# Iterations for PBKDF2
pbkdf2iterations = 1000

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

encrypt = (item, password, callback, encryption = defaultEncryption) ->
	isArray = shared.util.isArray(item)
	items = if isArray then item else [item]

	i = 0
	next = ->
		if i < items.length
			# Encrypt
			worker.execute "crypt.encrypt",
				item: items[i]
				password: password
				encryption: encryption
			, (result, id) ->
				items[i] = result
		else
			# Finished
			if isArray
				callback items
			else
				callback items[0]

	next()
	return

decrypt = (item, password, callback) ->
	isArray = shared.util.isArray(item)
	items = if isArray then item else [item]

	i = 0
	next = ->
		if i < items.length
			# Decrypt
			worker.execute "crypt.decrypt",
				item: items[i]
				password: password
			, (result, id) ->
				items[i] = result
		else
			# Finished
			if isArray
				callback items
			else
				callback items[0]

	next()
	return

key = (password, salt, callback) ->
	worker.execute "crypt.key",
		password: password
		salt: salt
		iterations: pbkdf2iterations
	, (result, id) ->
		callback(result)

	return

init = ->
	# Collect entropy
	buf = new Uint32Array(32)
	if window.crypto && window.crypto.getRandomValues
		window.crypto.getRandomValues buf
	else if window.msCrypto && window.msCrypto.getRandomValues
		window.msCrypto.getRandomValues buf
	else
		throw new Error("Unable to collect entropy.")

	# Send to webworker
	worker.execute "crypt.addEntropy", buf, (result, id) ->
		if !result? || result == false
			console.log "There was an error collecting entropy"

	return

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
module.exports.key = key
module.exports.init = init
module.exports.format = format
module.exports.availableEncryptions = availableEncryptions
