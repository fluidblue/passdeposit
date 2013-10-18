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
tags = require "./tags"
itemid = require "./itemid"

defaultAddOptions =
	open: false
	position: "bottom"
	focus: false

add = (item, options = null) ->
	# Merge options
	options = $.extend(true, {}, defaultAddOptions, options)

	# Create new item from template
	template = $("#mainpage .itemTemplate").clone()
	template.removeClass("hide")
	template.removeClass("itemTemplate")

	# Add title
	titleContainer = template.find(".header .title")

	if item.title?
		titleContainer.html($.trim(item.title))
	else
		titleContainer.html(format.title(item.fields))

	# Add info texts
	itemInfoContainer = template.find(".content .itemInfoContainer")

	itemInfoContainer.find(".infoEncryption").html(format.encryption(item.encryption.type))
	itemInfoContainer.find(".infoCreated").html(format.date(item.dateCreated))
	itemInfoContainer.find(".infoModified").html(format.date(item.dateModified))

	# Add fields
	fields.setFields(template, item.fields)

	# Add tags
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
	if options.position == "top"
		template.prependTo("#mainList")
	else
		template.appendTo("#mainList")

	# Show mainList
	show(true)

	# Focus first field
	if options.focus
		template.find(".itemFieldContainer > *:first-child").find("input[type=text]:visible, input[type=password]:visible").focus()

	return true

remove = (item) ->
	item.remove()
	visible = $("#mainList").children().length > 0
	show(visible)

clear = ->
	mainList = $("#mainList")

	mainList.children().each (i, elem) ->
		elem = $(elem)
		
		# Remove all items which are saved
		if itemid.get(elem) != 0
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
module.exports.clear = clear
