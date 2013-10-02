###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"

add = (item) ->
	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

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
				"value": "__crypted__"
			},
			{
				"type": "service",
				"value": "__crypted__"
			},
			{
				"type": "text",
				"value": "__crypted__"
			},
			{
				"type": "uri",
				"value": "__crypted__"
			},
			{
				"type": "user",
				"value": "__crypted__"
			},
			{
				"type": "pass",
				"value": "__crypted__"
			}
		],

		"tags": [
			123,
			124
		]
	}'
	add(item)

module.exports.init = init
module.exports.add = add
module.exports.clear = clear
