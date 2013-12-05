###
# PassDeposit #
itemlist tag manipulations

Created by Max Geissler
###

init = (item, tagList) ->
	input = item.find(".itemFieldTags .input-tag")

	# Add start values
	input.val tagList.join(", ")

	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: ["test", "test2"]
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
