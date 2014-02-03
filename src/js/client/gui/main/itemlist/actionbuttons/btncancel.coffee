###
# PassDeposit #
itemlist action button: cancel

Created by Max Geissler
###

itemid = require "../itemid"
itemlist = require ".."
core = require "../../../../core"

init = ->
	$(document).on "click", "#mainList .content .btnCancel", (e) ->
		item = $(this).closest(".item")
		id = itemid.get(item)

		if id == null
			itemlist.remove(item)
		else
			itemlist.replace item, core.items.get(id),
				open: item.hasClass("open")

		return

module.exports.init = init
