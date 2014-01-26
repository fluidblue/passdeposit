###
# PassDeposit #
WebWorker

Created by Max Geissler
###

search = require "./search"
crypt = require "./crypt"

self.addEventListener "message", (e) ->
	# Get parameters
	id = e.data.id
	data = e.data.data

	# Execute command
	result = switch e.data.cmd
		when "search" then search(data.pattern, data.items)
		when "crypt.encrypt" then crypt.encrypt(data.items, data.password, data.encryption)
		when "crypt.decrypt" then crypt.decrypt(data.items, data.password)
		when "crypt.key" then crypt.key(data.password, data.salt, data.iterations)
		when "crypt.addEntropy" then crypt.addEntropy(data)

	# Return result
	self.postMessage
		id: id
		result: result
, false
