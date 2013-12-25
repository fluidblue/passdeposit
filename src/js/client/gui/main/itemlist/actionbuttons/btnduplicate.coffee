###
# PassDeposit #
itemlist action button: duplicate

Created by Max Geissler
###

fields = require "../fields"
tags = require "../tags"
itemlist = require ".."
btnsave = require "../actionbuttons/btnsave"
global = require "../../../global"

init = ->
	$(document).on "click", "#mainList .content .btnDuplicate", (e) ->
		item = $(this).closest(".item")

		# Get tags
		tagList = tags.get(item)

		# Get fields
		fieldList = fields.getFields(item)

		# Save old item
		if !btnsave.save(item, tagList, fieldList, false)
			return

		# Close item
		item.removeClass("open")

		# Duplicate item
		newItem =
			title: global.text.get("addOther")

			fields: fieldList
			tags: tagList

		# Add duplicate
		itemlist.add newItem,
			open: true
			position: "top"
			focus: true

		# TODO: Resort or clear item list

		# Show notification
		global.jGrowl.show global.text.get("duplicatedItem")

		return

module.exports.init = init
