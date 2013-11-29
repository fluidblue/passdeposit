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
	# Make a copy of fieldList to have an unencrypted version for later.
	# Use JSON, because it is the most efficient way:
	# http://jsperf.com/cloning-an-object/2
	fieldListUnencrypted = JSON.parse(JSON.stringify(fieldList))

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

		# Get unencrypted item
		itemDecrypted = core.items.get(response.item.id)

		# Update gui
		itemid.set(item, response.item.id)
		info.set(item, itemDecrypted)

		# Show notification
		$.jGrowl text.get("itemSaveSucceeded")

	# Call core procedure
	if exist
		itemObj.id = id
		core.items.modify(itemObj, callback)
	else
		core.items.add(itemObj, callback)

	# Update quickbuttons
	quickbuttons.setButtons(item, fieldListUnencrypted)

	# Update title
	title = format.title(fieldListUnencrypted)
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
