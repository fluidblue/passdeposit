###
# PassDeposit #
itemlist action button: save

Created by Max Geissler
###

core = require "../../../core"
itemid = require "./itemid"
field = require "../field"

init = ->
	$(document).on "click", "#mainList .content .btnSave", (e) ->
		item = $(this).closest(".item")

		# Get fields
		fields = new Array()

		item.find(".itemField").each (i, elem) ->
			elem = $(elem)

			# Get value
			value = elem.find("input[type=text]:visible, input[type=password]:visible").val()

			# Get type
			type = field.getType(elem)

			# Add to array
			fields.push
				"type": type
				"value": value
			
			# Continue with loop
			return true
		
		# Get tags
		tags = new Array()

		val = item.find(".input-tag").val()
		if val? && val.length > 0
			for tag in val.split(",")
				tag = $.trim(tag)
				tags.push tag

		# Create item object
		itemObj =
			"fields": fields
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
