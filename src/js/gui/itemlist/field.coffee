###
# PassDeposit #
itemlist field manipulations

Created by Max Geissler
###

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

add = (itemFieldContainer, field) ->
	# Get field class
	fieldClass = getClass(field.type)

	# Clone field template
	fieldTemplate = $("#mainpage .itemFieldTemplates ." + fieldClass).clone()

	# Set field value
	fieldTemplate.find("input[type=password], input[type=text]").val(field.value)

	# Insert before tag field
	itemFieldContainer.children("*:last").before(fieldTemplate)

module.exports.find = find
module.exports.getType = getType
module.exports.getContainer = getContainer
module.exports.add = add
