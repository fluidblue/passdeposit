###
# PassDeposit #
itemlist tag manipulations

Created by Max Geissler
###

set = (item, tagList) ->
	# TODO
	console.log tagList

get = (item) ->
	tagList = new Array()

	val = item.find(".input-tag").val()
	if val? && val.length > 0
		for tag in val.split(",")
			tag = $.trim(tag)
			tagList.push tag

	return tagList

initTemplate = (template) ->
	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: ["test", "test2"]
		placeholder: "Tags"

	template.find(".itemFieldTags .input-tag").tag optTags

module.exports.initTemplate = initTemplate
module.exports.set = set
module.exports.get = get
