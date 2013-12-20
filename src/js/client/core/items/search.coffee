###
# PassDeposit #
Item search

Created by Max Geissler
###

fuse = require "fuse.js"
itemcache = require "./itemcache"
convert = require "../convert"

search = (pattern) ->
	rawResults = null
	results = []

	if pattern.toLowerCase() == ":all"
		rawResults = searchAll(pattern)
	else
		rawResults = searchFuzzy(pattern)

	# Create list of IDs
	for raw in rawResults
		results.push raw.id

	return results

searchAll = (pattern) ->
	rawResults = []

	# Show all items
	for id, item of itemcache.get()
		rawResults.push
			id: id
			date: convert.date(item.dateModified)

	# Sort the results
	rawResults.sort (a, b) ->
		return b.date - a.date

	return rawResults

searchFuzzy = (pattern) ->
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

	return rawResults

module.exports = search
