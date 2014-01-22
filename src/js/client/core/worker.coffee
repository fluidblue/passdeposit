###
# PassDeposit #
WebWorker access

Created by Max Geissler
###

worker = null
callbacks = {}
lastID = 0

nextID = ->
	lastID = (lastID + 1) % 65536
	return lastID

execute = (cmd, data, callback) ->
	# Get next ID
	id = nextID()

	# Save callback
	callbacks[id] = callback

	# Execute command
	worker.postMessage
		cmd: cmd
		data: data
		id: id

	# Return ID
	return id

init = ->
	# Initialize new WebWorker
	worker = new Worker("js/worker.js")

	# Listen to messages
	worker.addEventListener "message", (e) ->
		# Get callback
		callback = callbacks[e.data.id]

		# Fire callback with result
		callback(e.data.result, e.data.id)

		# Cleanup
		delete callbacks[e.data.id]
	, false

# Initialize immediately
init()

module.exports.execute = execute
