###
# PassDeposit #
Field tags

Created by Max Geissler
###

initTemplate = (template) ->
	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: ["test", "test2"]
		placeholder: "Tags"

	template.find(".itemFieldTags .input-tag").tag optTags

module.exports.initTemplate = initTemplate
