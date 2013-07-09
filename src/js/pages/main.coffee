###
# PassDeposit #
Main page initialization

Created by Max Geissler
###

require "jquery"
require "bootstrap"
require "bootstrap-tag"
initOptionsDialog = require "./main/options"
lockDialog = require "./main/lock"
logout = require "./main/logout"

initTags = ->
	optTags =
		caseInsensitive: true
		allowDuplicates: false
		source: ["test", "test2"]
		placeholder: "Tags"

	$("#mainpage .input-tag").tag optTags

# Initializes main page
init = ->
	initOptionsDialog()
	lockDialog.init()
	logout.init()
	initTags()
	
	# TODO: Multiple typeahead
	options = source: ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Dakota", "North Carolina", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
	$("#search").typeahead options

module.exports = init