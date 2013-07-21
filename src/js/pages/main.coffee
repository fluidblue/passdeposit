###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

initOptionsDialog = require "./main/options"
initDonationDialog = require "./main/donations"
lockDialog = require "./main/lock"
logout = require "./main/logout"

initTags = ->
	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: ["test", "test2"]
		placeholder: "Tags"

	$("#mainpage .input-tag").tag optTags

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

# Initializes main page
init = ->
	initOptionsDialog()
	initDonationDialog()
	lockDialog.init()
	logout.init()
	initTags()
	initAdvancedSearch()
	
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

module.exports = init
