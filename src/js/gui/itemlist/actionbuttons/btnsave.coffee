###
# PassDeposit #
itemlist action button: save

Created by Max Geissler
###

core = require "../../../core"
itemid = require "../itemid"
fields = require "../fields"
tags = require "../tags"
quickbuttons = require "../quickbuttons"
format = require "../format"
info = require "../info"
text = require "../../components/text"

save = (item, tagList, fieldList) ->
	# Create item object
	itemObj =
		"fields": fieldList
		"tags": tagList

	# Process item
	id = itemid.get(item)
	exist = id != 0

	# Define callback
	callback = (response) ->
		if response.status != "success"
			# Show error
			$.jGrowl text.get("itemSaveFailed", response.status)
			return

		# TODO: Update item cache

		# Update gui
		itemid.set(item, response.item.id)
		info.set(item, response.item)

		# Show notification
		$.jGrowl text.get("itemSaveSucceeded")

	# Call core procedure
	if exist
		itemObj.id = id
		core.item.modify(itemObj, callback)
	else
		core.item.add(itemObj, callback)

	# Update quickbuttons
	quickbuttons.setButtons(item, fieldList)

	# Update title
	title = format.title(fieldList)
	item.find(".header .title").html(title)

	return true

init = ->
	$(document).on "click", "#mainList .content .btnSave", (e) ->
		item = $(this).closest(".item")

		# Get tags
		tagList = tags.get(item)

		# Get fields
		fieldList = fields.getFields(item)

		# Save
		save(item, tagList, fieldList)

		return

module.exports.init = init
module.exports.save = save
