###
# PassDeposit #
itemlist action button: save

Created by Max Geissler
###

core = require "../../../core"
itemid = require "./itemid"
fields = require "../fields"

init = ->
	$(document).on "click", "#mainList .content .btnSave", (e) ->
		item = $(this).closest(".item")

		# Get tags
		tags = new Array()

		val = item.find(".input-tag").val()
		if val? && val.length > 0
			for tag in val.split(",")
				tag = $.trim(tag)
				tags.push tag

		# Create item object
		itemObj =
			"fields": fields.getFields(item)
			"tags": tags

		# Process item
		id = itemid.get(item)
		exist = id != 0

		if exist
			itemObj.id = id
			core.item.modify(itemObj)
		else
			core.item.add(itemObj)

		return

module.exports.init = init
