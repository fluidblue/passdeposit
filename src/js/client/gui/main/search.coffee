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

showAdvancedSearch = (show) ->
	searchBar = $(".searchBar")
	searchField = searchBar.children(".searchField")
	searchAdvancedButton = searchBar.children(".btn")
	searchAdvancedButtonLabel = searchAdvancedButton.children("span")

	if show
		searchField.popover "show"
		searchAdvancedButtonLabel.addClass("caretUp")
	else
		searchField.popover "hide"
		searchAdvancedButtonLabel.removeClass("caretUp")

initAdvancedSearch = ->
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
		showAdvancedSearch(!searchAdvancedButtonLabel.hasClass("caretUp"))
		return

	$(document).on "click", ".searchBarContainer a[href=#all]", (e) ->
		e.preventDefault()

		searchField.val ":all"

		searchField.triggerHandler("change")
		searchAdvancedButton.triggerHandler("click")

		return

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

	# Close advanced options
	showAdvancedSearch(false)

refresh = ->
	search(searchValue)

init = ->
	initAdvancedSearch()
	initSearchHandlers()

module.exports.init = init
module.exports.reset = reset
module.exports.refresh = refresh
