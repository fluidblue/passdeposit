###
# PassDeposit #
tagList

Created by Max Geissler
###

itemcache = require "./itemcache"

tagList = {}
tagArray = []

# TODO: Duplicate entries (in tagArray) are visible when editing tags sometimes.

add = (itemID, tags) ->
	for tag in tags
		if tagList[tag]?
			# Add itemID to existing tag
			tagList[tag].push itemID
		else
			# Create new tag
			tagList[tag] = [itemID]
			tagArray.push tag

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
				tagArray.splice(tagArray.indexOf(tag), 1)

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
				# Delete reference to item
				delete tagList[tag][indexTagList]

				# Remove entire tag entry, if no references are left
				if tagList[tag].length == 0
					delete tagList[tag]
					tagArray.splice(tagArray.indexOf(tag), 1)

	# Add new tags
	for tag in tags
		tagList[tag] = [itemID]
		tagArray.push tag

clear = ->
	tagList = {}
	tagArray = []

getArray = ->
	return tagArray

getList = ->
	return tagList

module.exports.add = add
module.exports.remove = remove
module.exports.modify = modify
module.exports.clear = clear
module.exports.getArray = getArray
module.exports.getList = getList
