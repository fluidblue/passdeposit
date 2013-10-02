###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"

add = (item) ->
	# TODO
	console.log item

	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

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
