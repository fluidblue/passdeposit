###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"

formatDate = (num) ->
	date = new Date(num)

	day = date.getDate()
	month = date.getMonth() + 1 # Months are zero based
	year = date.getFullYear()

	if day < 10
		day = "0" + day.toString()

	if month < 10
		month = "0" + month.toString()

	return year + "-" + month + "-" + day

formatEncryption = (enc) ->
	return switch enc
		when "aes256" then "AES 256"
		else "Unknown"

formatWebAddress = (addr) ->
	if addr.indexOf("http://") == 0
		return addr.substring(7)

	if addr.indexOf("https://") == 0
		return addr.substring(8)

	return addr

formatTitle = (item) ->
	title = ""
	dot = ' <span class="dot">•</span> '

	user = ""
	email = ""
	service = ""
	uri = ""
	text = ""

	# Loop through fields in reverse order
	for field in item.fields by -1
		switch field.type
			when "user" then user = field.value
			when "email" then email = field.value
			when "service" then service = field.value
			when "uri" then uri = formatWebAddress(field.value)
			when "text" then text = field.value

	# Create title:
	# (Username | Email) * (ServiceName) * (WebAddress) * (Text)
	# If only WebAddress & Text are present:
	# Text * WebAddress

	if user.length <= 0 && email.length <= 0 && service.length <= 0 &&
	uri.length > 0 && text.length > 0
		title = text + dot + uri
	else
		if user.length > 0
			title += user

		if title.length <= 0 && email.length > 0
			title += email

		if service.length > 0
			title += dot + service

		if uri.length > 0
			title += dot + uri

		if text.length > 0
			title += dot + text

	return title

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
	titleContainer.html(formatTitle(item))

	# Set quickbuttons
	buttonContainer = template.find(".header .buttons")

	if !getField(item.fields, "uri")?
		buttonContainer.find(".btnOpen").hide()

	if !getField(item.fields, "pass")?
		buttonContainer.find(".btnPass").hide()

	# Add info texts
	itemInfoContainer = template.find(".content .itemInfoContainer")

	itemInfoContainer.find(".infoEncryption").html(formatEncryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(formatDate(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(formatDate(item.dateModified))

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
	item = jQuery.parseJSON '{
		"dateCreated": 1335205592410,
		"dateModified": 1335205592410,

		"encryption": {
			"type": "aes256",
			"param0": 0,
			"param1": 1
		},

		"fields": [
			{
				"type": "email",
				"value": "fluidblue@gmail.com"
			},
			{
				"type": "service",
				"value": "ServiceName"
			},
			{
				"type": "text",
				"value": "Some text"
			},
			{
				"type": "uri",
				"value": "http://www.example.com"
			},
			{
				"type": "user",
				"value": "fluidblue"
			},
			{
				"type": "pass",
				"value": "password"
			}
		],

		"tags": [
			123,
			124
		]
	}'
	add(item)
	add(item)
	add(item)
	add(item)
	add(item)

module.exports.init = init
module.exports.add = add
module.exports.clear = clear
