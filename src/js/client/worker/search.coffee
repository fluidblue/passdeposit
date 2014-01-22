###
# PassDeposit #
WebWorker search module

Created by Max Geissler
###

fuse = require "fuse.js"

search = (pattern, items) ->
	rawResults = null

	if pattern.toLowerCase() == ":all"
		rawResults = searchAll(items)
	else
		rawResults = searchFuzzy(pattern, items)

	if rawResults?
		results = []

		# Create list of IDs
		for raw in rawResults
			results.push raw.id

		return results
	else
		return null

searchAll = (items) ->
	rawResults = []

	# Show all items
	for id, item of items
		rawResults.push
			id: id
			date: item.dateModified

	# Sort the results
	rawResults.sort (a, b) ->
		return b.date - a.date

	return rawResults

searchFuzzy = (pattern, items) ->
	rawResults = []

	options =
		caseSensitive: false
		threshold: 0.6

	searcher = new fuse.Searcher(pattern, options)

	# Search trough all items
	for id, item of items
		# Set starting score
		score = 0.0

		# Search trough all fields
		for field in items[id].fields
			# Do not search trough passwords
			if field.type == "pass"
				continue

			bitapResult = searcher.search(field.value)
			if bitapResult.isMatch
				# Use inverted bitap score
				score = Math.max(score, 1.0 - bitapResult.score)

		# Search through all tags
		for tag in items[id].tags
			bitapResult = searcher.search(tag)
			if bitapResult.isMatch
				# Use inverted bitap score
				score = Math.max(score, 1.0 - bitapResult.score)

		# Add to results, if matches were found
		if score > 0.0
			rawResults.push
				id: id
				score: score
				date: item.dateModified

	# Sort the results, from highest to lowest score
	# If score is the same, sort by date
	rawResults.sort (a, b) ->
		scoreDiff = b.score - a.score

		if scoreDiff == 0
			return b.date - a.date
		else
			return scoreDiff

	return rawResults

module.exports = search
