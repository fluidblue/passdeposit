###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

toggleview = require "./toggleview"
itemid = require "./itemid"
pagination = require "./pagination"

defaultAddOptions =
	open: false
	position: "bottom"
	focus: false

add = (item, options = null) ->
	# Merge options
	options = $.extend(true, {}, defaultAddOptions, options)

	tpl = template.create(item, options.open)

	# Add item to mainList
	if typeof options.position == "number"
		if options.position > 0
			$("#mainList > div:nth-child(" + options.position + ")").after(tpl)
		else
			tpl.prependTo("#mainList")
	else
		if options.position == "top"
			tpl.prependTo("#mainList")
		else
			tpl.appendTo("#mainList")

	# Show mainList
	show(true)

	# Fix width of tags
	if options.open
		$(window).triggerHandler("tags-fix-width")

	# Focus first field
	if options.focus
		tpl.find(".itemFieldContainer > *:first-child").find("input[type=text]:visible, input[type=password]:visible").focus()

	return true

remove = (item) ->
	item.remove()
	visible = $("#mainList").children().length > 0
	show(visible)

replace = (item, newItem, options = null) ->
	if !options?
		options = {}

	# Get old item's index
	options.position = item.index()

	# Remove old item
	item.remove()

	# Add new item
	add(newItem, options)

clear = (all = false) ->
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
		$("#pagination").show()
	else
		# Show landing page
		$("#mainList").hide()
		$("#landingPage").show()
		$("#pagination").hide()

init = ->
	toggleview.init()
	pagination.init()

module.exports.init = init
module.exports.add = add
module.exports.remove = remove
module.exports.replace = replace
module.exports.clear = clear
