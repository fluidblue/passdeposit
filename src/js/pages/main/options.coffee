###
# PassDeposit #
Options dialog

Created by Max Geissler
###

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
			$.jGrowl $("#text .optionsSaved").html()
		
		return

module.exports = init