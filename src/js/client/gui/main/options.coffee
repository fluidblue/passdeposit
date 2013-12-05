###
# PassDeposit #
Options dialog

Created by Max Geissler
###

text = require "../global/text"

init = ->
	### Initializes option dialog ###
	
	saveOptions = false

	$("#optionsDialog").on "show", ->
		saveOptions = false
		return

	$("#optionsDialog .btnDo").click ->
		if $("#optionsDialog .nav-pills a[href=#options-general]").parent().hasClass("active")
			saveOptions = true

		$("#optionsDialog").modal "hide"

		return

	$("#optionsDialog").on "hidden", ->
		if saveOptions
			$.jGrowl text.get("optionsSaved")
		
		return

module.exports.init = init
