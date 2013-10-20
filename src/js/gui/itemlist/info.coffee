###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

format = require "./format"

set = (template, item) ->
	itemInfoContainer = template.find(".content .itemInfoContainer")

	# Add info texts
	itemInfoContainer.find(".infoEncryption").html(format.encryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

module.exports.set = set
