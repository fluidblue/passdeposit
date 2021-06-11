###
# PassDeposit #
itemlist tag manipulations

Created by Max Geissler
###

core = require "../../../core"

init = (item, tagList) ->
	input = item.find(".itemFieldTags .input-tag")

	# Add start values
	input.val tagList.join(", ")

	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: (query, process) ->
			# TODO: Duplicate entries are visible when editing tags sometimes.
			# A cause could be: The library bootstrap-tag modifies the items
			# in the array returned by core.items.getTagArray().
			return core.items.getTagArray()
		placeholder: "Tags"

	input.tag optTags

get = (item) ->
	tagList = new Array()

	val = item.find(".input-tag").val()
	if val? && val.length > 0
		for tag in val.split(",")
			tag = $.trim(tag)
			tagList.push tag

	return tagList

module.exports.init = init
module.exports.get = get
