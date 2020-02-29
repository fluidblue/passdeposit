###
# PassDeposit #
itemlist quick buttons

Created by Max Geissler
###

format = require "./format"
fields = require "./fields"
global = require "../../global"

initButtons = (template) ->
	buttonContainer = template.find(".header .buttons")
	btnPass = buttonContainer.find(".btnPass")
	btnOpen = buttonContainer.find(".btnOpen")

	# Initialize tooltips
	options =
		placement: "top"
		trigger: "hover"
		animation: false

	options.title = global.text.get("openAddress")
	btnOpen.tooltip options

	options.title = global.text.get("copyPass")
	#options.trigger = "manual"
	btnPass.tooltip options

	# Initialize copy-to-clipboard on btnPass
	btnPass.on "click", (e) ->
		# Prepare data and show temporary input
		clipboardInput = $("#clipboard")
		clipboardInput.val(btnPass.data("pass"));
		clipboardInput.show()

		# Copy text to clipboard
		global.clipboard.copyText(clipboardInput);

		# Hide temporary input
		clipboardInput.hide()

		# Show info
		global.jGrowl.show global.text.get("copiedToClipboard")

		return false

	# btnPass.on "mouseover", (e) ->
	# 	global.clipboard.activate
	# 		element: this

	# 		dataRequested: (elem) ->
	# 			# Set data to be copied to clipboard
	# 			# TODO: Remove data on lock!
	# 			return $(elem).data("pass")

	# 		mouseover: (elem) ->
	# 			$(elem).addClass("active")
	# 			$(elem).closest(".item").addClass("active")
	# 			$(elem).tooltip("show")
	# 			return

	# 		mouseout: (elem) ->
	# 			$(elem).removeClass("active")
	# 			$(elem).closest(".item").removeClass("active")
	# 			$(elem).tooltip("hide")
	# 			return

	# 	# Prevent propagation to underlying .header
	# 	e.stopPropagation()
		
	# 	return

	# # Fix for ZeroClipboard's mouseout not firing
	# template.find(".header").on "mouseover", (e) ->
	# 	global.clipboard.deactivate()
	# 	return

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
	if fieldUri? then btnOpen.attr("href", format.validUri(fieldUri.value))
	if fieldPass? then btnPass.data("pass", fieldPass.value)

	# Set visibility of buttons
	setBtnVisible(btnOpen, fieldUri? && fieldUri.value.length > 0)
	setBtnVisible(btnPass, fieldPass? && fieldPass.value.length > 0)

module.exports.initTemplate = initButtons
module.exports.setButtons = setButtons
