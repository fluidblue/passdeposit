###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

optionsDialog = require "./options"
donationDialog = require "./donations"
lockDialog = require "./lock"
logout = require "./logout"
clipboard = require "./clipboard"
btnAdd = require "./btnAdd"
itemlist = require "./itemlist"
core = require "../../core"

search = (value) ->
	# Clear itemlist
	itemlist.clear()

	# Start searching when value is not empty
	if value.length > 0
		# TODO: Remove
		console.log value

		# TODO: Remove
		for id, item of core.items.get()
			itemlist.add(item)

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

initTypeahead = ->
	# TODO: Multiple typeahead
	options = source: ["Alabama", "Alaska", "Arizona", "Arkansas", "California",
		"Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii",
		"Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
		"Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
		"Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
		"New Mexico", "New York", "North Dakota", "North Carolina", "Ohio", "Oklahoma",
		"Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
		"Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia",
		"Wisconsin", "Wyoming"]

	$("#search").typeahead options

initSearchHandlers = ->
	maxlength = $("#search").attr("maxlength")
	searchValue = ""

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

init = ->
	initAdvancedSearch()
	initTypeahead()
	initSearchHandlers()

module.exports.init = init
