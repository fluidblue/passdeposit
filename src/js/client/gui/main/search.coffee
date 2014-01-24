###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

optionsDialog = require "./options"
donationDialog = require "./donations"
lockDialog = require "./lock"
logout = require "./logout"
btnAdd = require "./btnAdd"
itemlist = require "./itemlist"
core = require "../../core"

searchValue = ""

search = (value) ->
	# Start searching when value is not empty
	if value.length > 0
		# Search
		core.items.search value, (resultIDs) ->
			# Clear itemlist
			itemlist.clear(false)

			# Add items
			items = core.items.get()
			for result in resultIDs
				itemlist.add(items[result])
	else
		# Clear itemlist
		itemlist.clear(false)

initAdvancedSearch = ->
	# Init search field popover

	options =
		trigger: "manual"
		placement: "bottom"
		html: true
		content: $("#searchOptions").html()
		container: ".searchBarContainer"

	searchBar = $(".searchBar")
	searchField = searchBar.children(".searchField")
	searchAdvancedButton = searchBar.children(".btn")
	searchAdvancedButtonLabel = searchAdvancedButton.children("span")

	searchField.popover options

	searchAdvancedButton.click ->
		if searchAdvancedButtonLabel.hasClass("caretUp")
			searchField.popover "hide"
			searchAdvancedButtonLabel.removeClass("caretUp")
		else
			searchField.popover "show"
			searchAdvancedButtonLabel.addClass("caretUp")
		return

	$(document).on "click", ".searchBarContainer a[href=#all]", (e) ->
		e.preventDefault()

		searchField.val ":all"

		searchField.triggerHandler("change")
		searchAdvancedButton.triggerHandler("click")

		return

initTypeahead = ->
	# TODO: Multiple typeahead
	
	# options = source: ["Alabama", "Alaska", "Arizona", "Arkansas", "California",
	# 	"Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
	# 	"Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
	# 	"Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
	# 	"Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
	# 	"New Mexico", "New York", "North Dakota", "North Carolina", "Ohio", "Oklahoma",
	# 	"Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
	# 	"Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
	# 	"Wisconsin", "Wyoming"]

	# $("#search").typeahead options

initSearchHandlers = ->
	maxlength = $("#search").attr("maxlength")

	$("#search").on "keypress", (e) ->
		# Ignore enter
		if e.which == 13
			return

		searchField = $(this)
		value = searchField.val() + String.fromCharCode(e.which)

		if value.length > maxlength
			value = value.substr(0, maxlength)

		if searchValue != value
			searchValue = value
			search(value)

		return

	$("#search").on "change keyup input", (e) ->
		searchField = $(this)
		value = searchField.val()

		if searchValue != value
			searchValue = value
			search(value)

		return

reset = ->
	# Reset search field
	$("#search").val ""
	searchValue = ""

init = ->
	initAdvancedSearch()
	initTypeahead()
	initSearchHandlers()

module.exports.init = init
module.exports.reset = reset
