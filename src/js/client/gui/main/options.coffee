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
			global.jGrowl.show global.text.get("optionsSaved")
		
		return

	$("#options-import-csv a[href=#example]").on "click", (e) ->
		e.preventDefault()

		example = 'uri,service,user,pass,tags\n' +
		'http://example.com,,username,password,tag1\n' +
		',Skype,username,password,"tag1,tag2"'

		$("#options-import-csv textarea").val example
		$("#options-import-csv textarea").focus()

		return

module.exports.init = init
