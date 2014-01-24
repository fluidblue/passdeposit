###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

toggleview = require "./toggleview"
itemid = require "./itemid"
pagination = require "./pagination"
template = require "./template"

# Store items, which are currently not shown in GUI.
# These items are either before or after the current page.
# Note: itemsAfter may contain template creation functions instead of items.
itemsBefore = []
itemsAfter = []
itemsPerPage = 10

defaultAddOptions =
	open: false
	position: "bottom"
	focus: false

firstPage = (itemToTop = null) ->
	# Move all items in itemsBefore to the GUI list.
	while itemsBefore.length > 0
		itemsBefore.pop().prependTo("#mainList")

	# Add to top of GUI list
	if itemToTop != null
		itemToTop.prependTo("#mainList")

	# If there are more items than one page can hold,
	# we need to move items to itemsAfter.
	guiItems = numItemsShown()
	while guiItems > itemsPerPage
		moveItem = $("#mainList > div:last-child").detach()
		itemsAfter.unshift moveItem
		guiItems--

add = (item, options = null) ->
	# Merge options
	options = $.extend(true, {}, defaultAddOptions, options)

	# Define template creation function
	fnTemplate = ->
		return template.create(item, options.open)

	store = false

	if typeof options.position == "number"
		tpl = fnTemplate()

		# Directly add template, because position in GUI is known.
		# options.position is the zero-based index of the item in the GUI list.
		if options.position > 0
			$("#mainList > div:nth-child(" + options.position + ")").after(tpl)
		else
			tpl.prependTo("#mainList")
	else
		if options.position == "top"
			# We want to see an element which gets added to the top.
			# Thus we need to go to the first page.
			# The function firstPage(...) will make the given
			# argument (tpl) the topmost item.
			tpl = fnTemplate()
			firstPage(tpl)
		else
			if itemsAfter.length == 0 && numItemsShown() < itemsPerPage
				# There is enough space on the current page, so we
				# add the item to the GUI list.
				tpl = fnTemplate()
				tpl.appendTo("#mainList")
			else
				# Add item after all other items
				# Do not create the template yet, but only store the function.
				itemsAfter.push fnTemplate
				store = true

	# Show mainList
	show(true)

	# Fix width of tags
	if !store && options.open
		$(window).triggerHandler("tags-fix-width")

	# Focus first field
	if !store && options.focus
		tpl.find(".itemFieldContainer > *:first-child").find("input[type=text]:visible, input[type=password]:visible").focus()

	return true

ensureTemplate = (item) ->
	if typeof item == "function"
		return item()
	else
		return item

remove = (item) ->
	# Remove item
	item.remove()

	# Move one item from itemsAfter to GUI list
	if itemsAfter.length > 0
		item = itemsAfter.shift()
		item = ensureTemplate(item)
		item.appendTo("#mainList")

	visible = numItemsShown() > 0
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

clearItems = (items) ->
	# Safely clear items, preventing memory leaks.
	# Note: This is very time consuming and should rarely be used.
	$("<div>").append(items).empty()

clear = (clearUnsaved = true) ->
	if clearUnsaved
		clearItems(itemsBefore)
		itemsBefore = []

		clearItems(itemsAfter)
		itemsAfter = []

		$("#mainList").empty()
	else
		removeUnsavedItems = (items) ->
			itemsRemoved = []

			# Loop through array in reverse order.
			# This allows to remove elements from the array in the loop.
			i = items.length
			while i--
				# Remove all items which are saved (= which have an ID)
				if itemid.get(items[i]) != null
					itemsRemoved.push items.splice(i, 1)[0]
			
			clearItems(itemsRemoved)

			return items

		itemsBefore = removeUnsavedItems(itemsBefore)
		itemsAfter = removeUnsavedItems(itemsAfter)

		$("#mainList").children().each (i, elem) ->
			elem = $(elem)

			# Remove all items which are saved
			if itemid.get(elem) != null
				elem.remove()

			# Continue with loop
			return true

		# Show the first page
		firstPage()

	visible = numItemsShown() > 0
	show(visible)

show = (visible) ->
	if visible
		# Show mainList
		$("#landingPage").hide()
		$("#mainList").show()

		# Set pagination
		currentPage = itemsBefore.length / itemsPerPage
		pagination.set currentPage, numPages()
	else
		# Show landing page
		$("#mainList").hide()
		$("#landingPage").show()

		# Hide pagination
		pagination.hide()

paginationCallback = (page) ->
	itemsBeforeLength = page * itemsPerPage

	itemsAfterLength = numItems() - ((page + 1) * itemsPerPage)
	if itemsAfterLength < 0
		itemsAfterLength = 0

	while itemsBefore.length < itemsBeforeLength
		# Move item from GUI list to itemsBefore
		moveItem = $("#mainList > div:first-child").detach()
		itemsBefore.push moveItem

	while itemsBefore.length > itemsBeforeLength
		# Move item from itemsBefore to GUI list
		itemsBefore.pop().prependTo("#mainList")

	while itemsAfter.length < itemsAfterLength
		# Move item from GUI list to itemsAfter
		moveItem = $("#mainList > div:last-child").detach()
		itemsAfter.unshift moveItem

	while itemsAfter.length > itemsAfterLength
		# Move items from itemsAfter to GUI list
		item = itemsAfter.shift()
		item = ensureTemplate(item)
		item.appendTo("#mainList")

numItems = ->
	return itemsBefore.length + numItemsShown() + itemsAfter.length

numItemsShown = ->
	return $("#mainList > *").length

numPages = ->
	return Math.ceil(numItems() / itemsPerPage)

init = ->
	template.init()
	toggleview.init()
	pagination.init(paginationCallback)

module.exports.init = init
module.exports.add = add
module.exports.remove = remove
module.exports.replace = replace
module.exports.clear = clear
