###
# PassDeposit #
Item search

Created by Max Geissler
###

itemcache = require "./itemcache"
worker = require "../worker"

lastID = 0
lastCallback = null

finish = (result, id) ->
	if id == lastID
		lastCallback(result)

search = (pattern, callback) ->
	# Save callback
	lastCallback = callback

	# Start searching
	lastID = worker.execute "search",
		pattern: pattern
		items: itemcache.get()
	, finish

module.exports = search
