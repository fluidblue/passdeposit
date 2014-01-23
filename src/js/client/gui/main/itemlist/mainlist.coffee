###
# PassDeposit #
itemlist mainlist manipulations

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
toggleview = require "./toggleview"
actionbuttons = require "./actionbuttons"
menuaddfield = require "./menuaddfield"
format = require "./format"
fields = require "./fields"
tags = require "./tags"
itemid = require "./itemid"
info = require "./info"

add = (item, options) ->
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
	if options.open then template.addClass("open")

	# Set item's id
	itemid.set(template, item.id)

	# Add item to mainList
	if typeof options.position == "number"
		if options.position > 0
			$("#mainList > div:nth-child(" + options.position + ")").after(template)
		else
			template.prependTo("#mainList")
	else
		if options.position == "top"
			template.prependTo("#mainList")
		else
			template.appendTo("#mainList")

	# Show mainList
	show(true)

	# Fix width of tags
	if options.open
		$(window).triggerHandler("tags-fix-width")

	# Focus first field
	if options.focus
		template.find(".itemFieldContainer > *:first-child").find("input[type=text]:visible, input[type=password]:visible").focus()

	return true

remove = (item) ->
	item.remove()
	visible = $("#mainList").children().length > 0
	show(visible)

replace = (item, newItem, options) ->
	# Get old item's index
	options.position = item.index()

	# Remove old item
	item.remove()

	# Add new item
	add(newItem, options)

clear = (all) ->
	mainList = $("#mainList")

	if all
		mainList.empty()
	else
		mainList.children().each (i, elem) ->
			elem = $(elem)
			
			# Remove all items which are saved
			if itemid.get(elem) != null
				elem.remove()

			# Continue with loop
			return true

	visible = mainList.children().length > 0
	show(visible)

show = (visible) ->
	if visible
		# Show mainList
		$("#landingPage").hide()
		$("#mainList").show()
	else
		# Show landing page
		$("#mainList").hide()
		$("#landingPage").show()

init = ->
	fields.init()
	toggleview.init()
	actionbuttons.init()
	menuaddfield.init()
	quickbuttons.init()

module.exports.init = init
module.exports.add = add
module.exports.remove = remove
module.exports.replace = replace
module.exports.clear = clear
