###
# PassDeposit #
Item manipulations

Created by Max Geissler
###

fuse = require "fuse.js"
command = require "./command"
crypt = require "./crypt"
itemcache = require "./itemcache"
tagcache = require "./tagcache"

search = (pattern) ->
	rawResults = []

	options =
		caseSensitive: false
		threshold: 0.6

	searcher = new fuse.Searcher(pattern, options)
	items = itemcache.get()

	# Search trough all items
	for id, item of items
		score = 0.0

		# Search trough all fields
		for field in items[id].fields
			# Do not search trough passwords
			if field.type == "pass"
				continue

			bitapResult = searcher.search(field.value)
			if bitapResult.isMatch
				# Add inverted bitap score
				score += 1.0 - bitapResult.score

		# Search through all tags
		for tag in items[id].tags
			bitapResult = searcher.search(tag)
			if bitapResult.isMatch
				# Add inverted bitap score
				score += 1.0 - bitapResult.score

		# Add to results, if matches were found
		if score > 0.0
			rawResults.push
				id: id
				score: score

	# Sort the results, from highest to lowest score
	rawResults.sort (a, b) ->
		return b.score - a.score

	# Create list of IDs
	results = []
	for raw in rawResults
		results.push raw.id

	return results

add = (item, callback) ->
	# Encrypt
	itemCrypted = crypt.encrypt(item)

	# Send command to server
	command.send
		cmd: "item.add"
		data: itemCrypted
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.add(response.item)

			callback(response)

modify = (item, callback) ->
	# Encrypt
	itemCrypted = crypt.encrypt(item)
	
	# Send command to server
	command.send
		cmd: "item.modify"
		data: itemCrypted
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.modify(response.item)

			callback(response)

remove = (id, callback) ->
	# Send command to server
	command.send
		cmd: "item.remove"
		data: id
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				# Update item cache
				itemcache.remove(id)

			callback(response)

load = (callback) ->
	# Get all items from server
	command.send
		cmd: "item.get"
		authenticate: true
		callback: (response) ->
			if response.status == "success"
				for item in response.items
					# Update item cache
					itemcache.add(item)
			else
				console.log "Error: Loading items failed: " + response.status

			callback(response)

module.exports.search = search
module.exports.add = add
module.exports.modify = modify
module.exports.remove = remove
module.exports.get = itemcache.get
module.exports.load = load
module.exports.getTagArray = tagcache.getArray
