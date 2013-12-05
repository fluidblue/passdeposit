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

		if id == 0
			itemlist.remove(item)
		else
			# TODO
			console.log "reset data"
			item.removeClass("open")
		
		return

module.exports.init = init
