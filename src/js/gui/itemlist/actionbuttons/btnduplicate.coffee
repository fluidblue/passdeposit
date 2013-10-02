###
# PassDeposit #
itemlist action button: duplicate

Created by Max Geissler
###

itemid = require "./itemid"

init = ->
	$(document).on "click", "#mainList .content .btnDuplicate", (e) ->
		item = $(this).closest(".item")

		# Save item
		item.find(".content .btnSave").trigger("click")

		# Mark current item as new
		itemid.set(item, 0)

		# TODO: Resort or clear item list

		# Show notification
		$.jGrowl $("#text .duplicatedItem").html()

		# Hide tooltip
		$(this).tooltip("hide")

		return

module.exports.init = init
