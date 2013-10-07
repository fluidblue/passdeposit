###
# PassDeposit #
itemlist quick buttons

Created by Max Geissler
###

format = require "./format"
fields = require "./fields"

initTooltips = (template) ->
	buttonContainer = template.find(".header .buttons")

	options =
		placement: "top"
		trigger: "hover focus"
		animation: false

	options.title = $("#text .copyPass").html()
	buttonContainer.find(".btnPass").tooltip options

	options.title = $("#text .openAddress").html()
	buttonContainer.find(".btnOpen").tooltip options

initBtnPass = ->
	$(document).on "click", "#mainList .item .header a.btnPass", (e) ->
		value = $(this).data("pass")
		
		# TODO: Copy to clipboard
		console.log("copy to clipboard: " + value)

		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		e.preventDefault()
		return

setBtnVisible = (btn, visible) ->
	# jQuery's hide() and show() don't work here,
	# because they break the design.

	# Default display value:
	defaultDisplay = "inline-block"

	if visible
		btn.css("display", defaultDisplay)
	else
		btn.css("display", "none")

setButtons = (item, fieldList) ->
	buttonContainer = item.find(".header .buttons")
	btnOpen = buttonContainer.find(".btnOpen")
	btnPass = buttonContainer.find(".btnPass")

	# Get fields
	fieldUri = fields.find(fieldList, "uri")
	fieldPass = fields.find(fieldList, "pass")

	# Set data for buttons
	if fieldUri? then btnOpen.attr("href", fieldUri.value)
	if fieldPass? then btnPass.data("pass", fieldPass.value)

	# Set visibility of buttons
	setBtnVisible(btnOpen, fieldUri? && fieldUri.length > 0)
	setBtnVisible(btnPass, fieldPass? && fieldPass.length > 0)

initTemplate = (template) ->
	initTooltips(template)

init = ->
	# Add button event
	initBtnPass()

module.exports.initTemplate = initTemplate
module.exports.init = init
module.exports.setButtons = setButtons
