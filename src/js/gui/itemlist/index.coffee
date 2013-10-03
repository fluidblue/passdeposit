###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"
format = require "./format"

# Return first field that matches the given type.
# If no such field is found, null is returned.
getField = (fields, type) ->
	for field in fields
		if field.type == type
			return field

	return null

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

	if !getField(item.fields, "uri")?
		buttonContainer.find(".btnOpen").hide()

	if !getField(item.fields, "pass")?
		buttonContainer.find(".btnPass").hide()

	# Add info texts
	itemInfoContainer = template.find(".content .itemInfoContainer")

	itemInfoContainer.find(".infoEncryption").html(format.encryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

	# Add fields
	itemFieldContainer = template.find(".content .itemFieldContainer")

	# Loop through fields in reverse order
	for field in item.fields by -1
		# Get field class
		fieldClass = switch field.type
			when "email" then "itemFieldEmail"
			when "pass" then "itemFieldPassword"
			when "service" then "itemFieldServiceName"
			when "uri" then "itemFieldWebAddress"
			when "user" then "itemFieldUser"
			else "itemFieldText"

		# Clone field template
		fieldTemplate = $("#mainpage .itemFieldTemplates ." + fieldClass).clone()

		# Set field value
		fieldTemplate.find("input[type=password], input[type=text]").val(field.value)

		# Add field template
		fieldTemplate.prependTo(itemFieldContainer)

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

	# TODO: Remove
	items = require "./testfields.json"
	for item in items
		add(item)

module.exports.init = init
module.exports.add = add
module.exports.clear = clear
