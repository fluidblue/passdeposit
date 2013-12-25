###
# PassDeposit #
itemlist action button: cancel

Created by Max Geissler
###

itemid = require "../itemid"
itemlist = require ".."

init = ->
	$(document).on "click", "#mainList .content .btnCancel", (e) ->
		item = $(this).closest(".item")
		id = itemid.get(item)

		if id == null
			itemlist.remove(item)
		else
			# TODO: Reset data
			console.log "reset data"

			# TODO: Remove invalid status on all items

			item.removeClass("open")
		
		return

module.exports.init = init
