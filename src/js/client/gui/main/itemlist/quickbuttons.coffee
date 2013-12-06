###
# PassDeposit #
itemlist quick buttons

Created by Max Geissler
###

format = require "./format"
fields = require "./fields"
global = require "../../global"

initTooltips = (template) ->
	buttonContainer = template.find(".header .buttons")

	options =
		placement: "top"
		trigger: "hover focus"
		animation: false

	options.title = global.text.get("copyPass")
	buttonContainer.find(".btnPass").tooltip options

	options.title = global.text.get("openAddress")
	buttonContainer.find(".btnOpen").tooltip options

initBtnPass = ->
	$(document).on "click", "#mainList .item .header a.btnPass", (e) ->
		e.preventDefault()

		value = $(this).data("pass")
		
		# TODO: Copy to clipboard
		console.log("copy to clipboard: " + value)

		# Show notification
		global.jGrowl.show global.text.get("copiedToClipboard")

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
	setBtnVisible(btnOpen, fieldUri? && fieldUri.value.length > 0)
	setBtnVisible(btnPass, fieldPass? && fieldPass.value.length > 0)

initTemplate = (template) ->
	initTooltips(template)

init = ->
	# Add button event
	initBtnPass()

module.exports.initTemplate = initTemplate
module.exports.init = init
module.exports.setButtons = setButtons
