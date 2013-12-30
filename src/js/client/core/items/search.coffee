###
# PassDeposit #
Item search

Created by Max Geissler
###

itemcache = require "./itemcache"

worker = null

lastSearchID = 0
lastCallback = null

init = ->
	# Initialize new WebWorker
	worker = new Worker("js/worker.js")

	# Listen to messages
	worker.addEventListener "message", (e) ->
		if e.data.id == lastSearchID
			lastCallback(e.data.result)
	, false

search = (pattern, callback) ->
	# Generate new searchID
	searchID = (lastSearchID + 1) % 1024

	# Save searchID and callback
	lastSearchID = searchID
	lastCallback = callback

	# Start searching
	worker.postMessage
		id: searchID
		pattern: pattern
		items: itemcache.get()

# Initialize immediately
init()

module.exports = search
