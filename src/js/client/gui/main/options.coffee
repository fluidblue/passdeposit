###
# PassDeposit #
Options dialog

Created by Max Geissler
###

global = require "../global"

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
			$.jGrowl global.text.get("optionsSaved")
		
		return

module.exports.init = init
