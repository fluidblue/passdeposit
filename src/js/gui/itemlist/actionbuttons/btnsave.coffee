###
# PassDeposit #
itemlist action button: save

Created by Max Geissler
###

core = require "../../../core"
itemid = require "./itemid"
fields = require "../fields"
quickbuttons = require "../quickbuttons"
format = require "../format"

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

		# Get fields
		fieldList = fields.getFields(item)

		# Create item object
		itemObj =
			"fields": fieldList
			"tags": tags

		# Process item
		id = itemid.get(item)
		exist = id != 0

		if exist
			itemObj.id = id
			core.item.modify(itemObj)
		else
			core.item.add(itemObj)

		# Update quickbuttons
		quickbuttons.setButtons(item, fieldList)

		# Update title
		title = format.title(fieldList)
		item.find(".header .title").html(title)

		return

module.exports.init = init
