###
# PassDeposit #
item template creation

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
actionbuttons = require "./actionbuttons"
menuaddfield = require "./menuaddfield"
format = require "./format"
fields = require "./fields"
tags = require "./tags"
itemid = require "./itemid"
info = require "./info"

create = (item, open) ->
	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

	# Add title
	title = if item.title? then item.title else format.title(item.fields)
	titleContainer = template.find(".header .title").html(title)

	# Set item's values
	info.set(template, item)
	fields.setFields(template, item.fields)
	tags.init(template, item.tags)

	# Set quickbuttons
	quickbuttons.setButtons(template, item.fields)

	# Initialize buttons
	quickbuttons.initTemplate(template)
	actionbuttons.initTemplate(template)

	# Open item
	if open then template.addClass("open")

	# Set item's id
	itemid.set(template, item.id)

	return template

init = ->
	fields.init()
	actionbuttons.init()
	menuaddfield.init()

module.exports.create = create
module.exports.init = init
