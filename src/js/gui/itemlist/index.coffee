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
field = require "./field"

add = (item) ->
	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

	# Add title
	titleContainer = template.find(".header .title")
	titleContainer.html(format.title(item))

	# Set quickbuttons
	buttonContainer = template.find(".header .buttons")

	if !field.find(item.fields, "uri")?
		buttonContainer.find(".btnOpen").hide()

	if !field.find(item.fields, "pass")?
		buttonContainer.find(".btnPass").hide()

	# Add info texts
	itemInfoContainer = template.find(".content .itemInfoContainer")

	itemInfoContainer.find(".infoEncryption").html(format.encryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

	# Add fields
	itemFieldContainer = field.getContainer(template)

	for f in item.fields
		field.add(itemFieldContainer, f)

	# Initialize template
	quickbuttons.initTemplate(template)
	actionbuttons.initTemplate(template)

	# Add item to mainList
	template.appendTo("#mainList")

clear = ->
	$("#mainList").empty()

init = ->
	toggleview.init()
	actionbuttons.init()
	menuaddfield.init()

	# TODO: Remove
	items = require "./testfields.json"
	for item in items
		add(item)

module.exports.init = init
module.exports.add = add
module.exports.clear = clear
