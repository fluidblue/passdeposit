###
# PassDeposit #
WebWorker

Created by Max Geissler
###

search = require "./search"
crypt = require "./crypt"

self.addEventListener "message", (e) ->
	# Execute command
	result = switch e.data.cmd
		when "search" then search.start(e.data.id, e.data.data)
		when "encrypt" then crypt.encrypt(e.data.data)
		when "decrypt" then crypt.decrypt(e.data.data)

	# Return result
	self.postMessage
		id: e.data.id
		result: result
, false
