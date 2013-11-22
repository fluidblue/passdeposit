###
# PassDeposit #
tagList

Created by Max Geissler
###

tagList = []

add = (tag, itemID) ->
	for entry in tagList
		if entry.tag == tag
			# Add reference to existing entry
			entry.items[] = itemID
			return

	# Add new entry
	tagList[] =
		tag: tag
		items: [itemID]

remove = (tag, itemID) ->
	for key, entry of tagList
		if entry.tag == tag
			# Delete reference to this item
			index = entry.items.indexOf(itemID)

			if index != -1
				delete entry.items[index]

			# Remove entire tag entry, if no references are left
			if entry.items.length == 0
				tagList.splice(key, 1)

			return

update = (prevTags, newTags, itemID) ->
	prevIndex = oldTags.length - 1

	while prevIndex >= 0
		newIndex = newTags.indexOf(oldTags[i])

		# If tag is present in both prevTags and newTags,
		# we don't need to modify it.
		if newIndex != -1
			delete prevTags[prevIndex]
			delete newTags[newIndex] 

		prevIndex--

	# prevTags now contain tags to be removed
	for tag in prevTags
		remove(tag, itemID)

	# newTags now contain tags to be added
	for tag in newTags
		add(tag, itemID)

save = ->
	# TODO

module.exports.update = update
module.exports.save = save
