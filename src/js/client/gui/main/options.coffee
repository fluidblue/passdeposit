###
# PassDeposit #
Options dialog

Created by Max Geissler
###

global = require "../global"
core = require "../../core"
shared = require "../../../shared"
format = require "./itemlist/format"
username = require "../front/username"

startsWith = (data, str) ->
	return data.lastIndexOf(str, 0) == 0

importCSV = ->
	data = $("#options-import-csv textarea").val()
	tag = $("#options-import-csv input").val()

	core.convert.import "csv", data, tag, (response, count, ignored) ->
		if response.status == "success"
			if count == 0
				global.jGrowl.show global.text.get("importFailedNoItems")
			else
				if ignored == 0
					global.jGrowl.show global.text.get("importSuccess", count)
				else
					global.jGrowl.show global.text.get("importSuccessWithWarning", count, ignored)

				# Reset fields
				$("#options-import-csv input").val ""
				$("#options-import-csv textarea").val ""
		else if response.status == "import:data:failed"
			global.jGrowl.show global.text.get("importFailedInvalidData")
		else
			global.jGrowl.show global.text.get("importFailed", response.status)

	return true

changeEmail = ->
	emailField = $("#changeEmail")
	email = emailField.val()

	if !shared.validation.email(email)
		global.form.setInputInvalid emailField
		emailField.focus()
		return false

	core.user.updateEmail email, (response) ->
		if response.status == "success"
			username.save(email)
			global.jGrowl.show global.text.get("optionsSaved")
		else if response.status == "db:duplicate"
			global.jGrowl.show global.text.get("changeEmailDuplicate")
		else
			global.jGrowl.show global.text.get("optionsSaveFailed", response.status)

	return true

validatePasswordChangeFields = ->
	# Define field validation function
	validateField = (jqElem, fn) ->
		if !fn(jqElem.val())
			global.form.setInputInvalid jqElem
			return false
		
		return true

	# Validation function for password repeat field
	passwordRepeat = (str) ->
		return str == $("#changePass").val() && str.length > 0

	# Validate all fields and return result
	return validateField($("#changePass"), shared.validation.password) &
	validateField($("#changePassRepeat"), passwordRepeat) &
	validateField($("#changePassHint"), shared.validation.passwordHint)

changePassword = ->
	if !validatePasswordChangeFields()
		global.form.focus "#options-password"
		return false

	core.user.updatePassword $("#changePass").val(), $("#changePassHint").val(), (response) ->
		if response.status == "success"
			global.jGrowl.show global.text.get("optionsSaved")
		else
			global.jGrowl.show global.text.get("optionsSaveFailed", response.status)

	$("#optionsDialog").one "hidden", ->
		# Clear data
		$("#changePass").val ""
		$("#changePassRepeat").val ""
		$("#changePassHint").val ""
		
		return

	return true

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
			$("#changeEmail").val core.user.getEmail()

		# Set default import tag
		if $("#options-import-csv input").val().length == 0
			$("#options-import-csv input").val "import-" + format.date()

		return

	$("#optionsDialog .btnDo").click ->
		hideDialog = true

		# TODO: Use .one "hidden" everywhere
		if $("#options-general").is(":visible")
			$("#optionsDialog").one "hidden", ->
				global.jGrowl.show global.text.get("optionsSaved")
				return
		else if $("#options-email").is(":visible")
			hideDialog = changeEmail()
		else if $("#options-password").is(":visible")
			hideDialog = changePassword()
		else if $("#options-import-csv").is(":visible")
			hideDialog = importCSV()

		if hideDialog
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
