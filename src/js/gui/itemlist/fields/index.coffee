###
# PassDeposit #
itemlist field manipulations

Created by Max Geissler
###

buttons = require "./buttons"
menu = require "./menu"
tags = require "./tags"
tooltips = require "./tooltips"

# Return first field that matches the given type.
# If no such field is found, null is returned.
find = (fields, type) ->
	for field in fields
		if field.type == type
			return field

	return null

getClass = (type) ->
	return switch type
		when "email" then "itemFieldEmail"
		when "pass" then "itemFieldPassword"
		when "service" then "itemFieldServiceName"
		when "uri" then "itemFieldWebAddress"
		when "user" then "itemFieldUser"
		else "itemFieldText"

getType = (elem) ->
	type = "text"

	if elem.hasClass("itemFieldEmail")
		type = "email"
	else if elem.hasClass("itemFieldPassword")
		type = "pass"
	else if elem.hasClass("itemFieldServiceName")
		type = "service"
	else if elem.hasClass("itemFieldWebAddress")
		type = "uri"
	else if elem.hasClass("itemFieldUser")
		type = "user"

	return type

getContainer = (item) ->
	return item.find(".content .itemFieldContainer")

createTemplate = (field) ->
	# Get field class
	fieldClass = getClass(field.type)

	# Clone field template
	fieldTemplate = $("#mainpage .itemFieldTemplates ." + fieldClass).clone()

	# Set field value
	fieldTemplate.find("input[type=password], input[type=text]").val(field.value)

	# Return initialized template
	return fieldTemplate

add = (itemFieldContainer, field) ->
	# Create new field
	fieldTemplate = createTemplate(field)

	# Insert before tag field
	return fieldTemplate.insertBefore(itemFieldContainer.children("*:last"))

replace = (elem, field) ->
	# Create new field
	fieldTemplate = createTemplate(field)

	# Insert before tag field
	fieldTemplate.insertBefore(elem)
	elem.remove()

	# Return new field
	return fieldTemplate

getFields = (item) ->
	fieldList = new Array()

	item.find(".itemField").each (i, elem) ->
		elem = $(elem)

		# Get value
		value = ""
		elem.find("input[type=text], input[type=password]").each (i, elem) ->
			elem = $(elem)

			if elem.css("display") != "none"
				value = elem.val()

				# Break loop
				return false

			# Continue loop
			return true

		# Get type
		type = getType(elem)

		# Add to array
		fieldList.push
			"type": type
			"value": value
		
		# Continue with loop
		return true

	return fieldList

initTemplate = (template) ->
	tags.initTemplate(template)

init = ->
	tooltips.init()
	buttons.init()
	menu.init()

module.exports.init = init
module.exports.initTemplate = initTemplate
module.exports.find = find
module.exports.getType = getType
module.exports.getContainer = getContainer
module.exports.add = add
module.exports.replace = replace
module.exports.getFields = getFields
