###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

format = require "./format"
core = require "../../../core"

set = (template, item) ->
	itemInfoContainer = template.find(".content .itemInfoContainer")

	# Add info texts
	itemInfoContainer.find(".infoEncryption").html(core.crypt.format(item.encryption))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

module.exports.set = set
