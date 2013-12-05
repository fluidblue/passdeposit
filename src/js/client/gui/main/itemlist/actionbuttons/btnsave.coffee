###
# PassDeposit #
itemlist action button: save

Created by Max Geissler
###

core = require "../../../../core"
itemid = require "../itemid"
fields = require "../fields"
tags = require "../tags"
quickbuttons = require "../quickbuttons"
format = require "../format"
info = require "../info"
global = require "../../../global"

save = (item, tagList, fieldList, showSuccessNotification = true) ->
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
			$.jGrowl global.text.get("itemSaveFailed", response.status)
			return

		# Get unencrypted item
		itemDecrypted = core.items.get(response.item.id)

		# Update gui
		itemid.set(item, response.item.id)
		info.set(item, itemDecrypted)

		# Show notification
		if showSuccessNotification
			$.jGrowl global.text.get("itemSaveSucceeded")

	# Call core procedure
	if exist
		itemObj.id = id
		core.items.modify(itemObj, callback)
	else
		core.items.add(itemObj, callback)

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
