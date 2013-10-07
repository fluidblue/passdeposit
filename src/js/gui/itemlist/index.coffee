###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"
menuaddfield = require "./menuaddfield"
format = require "./format"
fields = require "./fields"
itemid = require "./itemid"

add = (item, open = false) ->
	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

	# Add title
	titleContainer = template.find(".header .title")

	if item.title?
		titleContainer.html(item.title)
	else
		titleContainer.html(format.title(item.fields))

	# Add info texts
	itemInfoContainer = template.find(".content .itemInfoContainer")

	itemInfoContainer.find(".infoEncryption").html(format.encryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

	# Add fields
	itemFieldContainer = fields.getContainer(template)

	for field in item.fields
		fields.add(itemFieldContainer, field)

	# Set quickbuttons
	quickbuttons.setButtons(template, item.fields)

	# Initialize template
	quickbuttons.initTemplate(template)
	actionbuttons.initTemplate(template)
	fields.initTemplate(template)

	# Open item
	if open then template.addClass("open")

	# Set item's id
	itemid.set(template, item.id)

	# Add item to mainList
	template.appendTo("#mainList")

clear = ->
	$("#mainList").empty()

init = ->
	fields.init()
	toggleview.init()
	actionbuttons.init()
	menuaddfield.init()
	quickbuttons.init()

	# TODO: Remove
	items = require "./testfields.json"
	for item in items
		add(item)

module.exports.init = init
module.exports.add = add
module.exports.clear = clear
