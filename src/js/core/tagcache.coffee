###
# PassDeposit #
tagList

Created by Max Geissler
###

itemcache = require "./itemcache"

tagList = {}

add = (itemID, tags) ->
	for tag in tags
		if tagList[tag]?
			# Add itemID to existing tag
			tagList[tag].push itemID
		else
			# Create new tag
			tagList[tag] = [itemID]

remove = (itemID) ->
	for tag of tagList
		if tagList[tag]?
			index = tagList[tag].indexOf(itemID)

			# Delete reference to item
			if index != -1
				delete tagList[tag][index]

			# Remove entire tag entry, if no references are left
			if tagList[tag].length == 0
				delete tagList[tag]

modify = (itemID, tags) ->
	# Remove old tags
	for tag of tagList
		# Check if itemID is referenced
		indexTagList = tagList[tag].indexOf(itemID)

		if indexTagList != -1
			# Check if the tag is present in new tags
			indexTags = tags.indexOf(tag)
			if indexTags != -1
				delete tags[indexTags]
			else
				delete tagList[tag][indexTagList]

	# Add new tags
	for tag in tags
		tagList[tag] = [itemID]

module.exports.add = add
module.exports.remove = remove
module.exports.modify = modify
