###
# PassDeposit #
Options dialog

Created by Max Geissler
###

global = require "../global"
core = require "../../core"
format = require "./itemlist/format"

startsWith = (data, str) ->
	return data.lastIndexOf(str, 0) == 0

importCSV = ->
	data = $("#options-import-csv textarea").val()
	tag = $("#options-import-csv input").val()

	core.convert.import "csv", data, tag, (response, count) ->
		if response.status == "success"
			if count == 0
				global.jGrowl.show global.text.get("importFailedNoItems")
			else
				global.jGrowl.show global.text.get("importSuccess", count)

				# Reset fields
				$("#options-import-csv input").val ""
				$("#options-import-csv textarea").val ""
		else
			global.jGrowl.show global.text.get("importFailed", response.status)

reset = ->
	# Reset email tab
	$("#changeEmail").val ""

	# Reset csv-import tab
	$("#options-import-csv input").val ""
	$("#options-import-csv textarea").val ""

	# Set initial tab
	global.navPills.change "#optionsNav", "#options-general", false

init = ->
	### Initializes option dialog ###

	$("#optionsDialog").on "show", ->
		# Load email address
		email = $("#changeEmail")
		if email.val().length <= 0
			$("#changeEmail").val $("#loginUser").val()

		# Set default import tag
		if $("#options-import-csv input").val().length == 0
			$("#options-import-csv input").val "import-" + format.date()

		return

	$("#optionsDialog .btnDo").click ->
		if $("#options-general").is(":visible")
			$("#optionsDialog").one "hidden", ->
				global.jGrowl.show global.text.get("optionsSaved")
				return
		else if $("#options-import-csv").is(":visible")
			$("#optionsDialog").one "hidden", ->
				importCSV()
				return
		else if $("#options-email").is(":visible")
			$("#changeEmail").val $("#loginUser").val

		$("#optionsDialog").modal "hide"

		return

	$("#optionsDialog .nav-pills li:not(.dropdown) > a").data "callback", (href) ->
		buttonText = if startsWith(href, "#options-import")
				global.text.get("import")
			else if startsWith(href, "#options-export")
				global.text.get("export")
			else
				global.text.get("save")

		$("#optionsDialog .btnDo").html buttonText

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
module.exports.reset = reset
