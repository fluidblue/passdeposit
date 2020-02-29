###
# PassDeposit #
Field buttons

Created by Max Geissler
###

format = require "../format"
global = require "../../../global"

initBtnCopy = (template) ->
	btnCopy = template.find(".btnCopy")

	# Initialize copy-to-clipboard on copy button
	btnCopy.on "click", (e) ->
		field = $(this).closest(".itemField")

		needVisibilityToggle = false
		input = field.find("input[type=text]:visible")

		# The html5 clipboard api only works for visible text fields.
		# Therefore make password field temporarily visible.
		if not (input? && input.length? && input.length > 0)
			# input is of type: input[type=password]
			needVisibilityToggle = true
			setPasswordVisibility(field, "toggle")
			input = field.find("input[type=text]:visible")

		# Copy text to clipboard
		global.clipboard.copyText(input);

		# Restore visibility setting for password field
		if needVisibilityToggle
			setPasswordVisibility(field, "toggle")

		# Show info
		global.jGrowl.show global.text.get("copiedToClipboard")

		return

	# btnCopy.on "mouseover", (e) ->
	# 	global.clipboard.activate
	# 		element: this

	# 		dataRequested: (elem) ->
	# 			# Set data to be copied to clipboard
	# 			field = $(elem).closest(".itemField")
	# 			input = field.find("input[type=text]:visible, input[type=password]:visible")
	# 			return input.val()

	# 		mouseover: (elem) ->
	# 			$(elem).addClass("btn-hover")
	# 			return

	# 		mouseout: (elem) ->
	# 			$(elem).removeClass("btn-hover")
	# 			$(elem).removeClass("btn-active")
	# 			$(elem).blur()
	# 			return

	# 		mousedown: (elem) ->
	# 			$(elem).addClass("btn-active")
	# 			return

	# 		mouseup: (elem) ->
	# 			$(elem).removeClass("btn-active")
	# 			return
		
	# 	# Prevent propagation to underlying div
	# 	e.stopPropagation()
		
	# 	return

	# Fix for ZeroClipboard's mouseout not firing
	template.on "mouseover", (e) ->
		global.clipboard.deactivate()
		return

initBtnOpen = ->
	$(document).on "click", "#mainList .itemField .btnOpen", (e) ->
		input = $(this).closest(".itemField").find("input[type=text]")
		uri = input.val()
		
		# Cancel if field is empty
		if uri.length == 0
			# Show notification
			input.attr("data-original-title", global.text.get("emptyURI")).tooltip("fixTitle")

			# Restore original tooltip
			input.one "blur.tooltipRestore", ->
				input.attr("data-original-title", global.text.get("infoURI")).tooltip("fixTitle")
				input.off "keydown.tooltipRestore"

			input.one "keydown.tooltipRestore", ->
				input.attr("data-original-title", global.text.get("infoURI")).tooltip("fixTitle")
				input.off "blur.tooltipRestore"
				input.tooltip("show")
			
			# Set focus
			input.focus()

			return
		
		# Open new window
		window.open format.validUri(uri)

		return

setPasswordVisibility = (itemField, visible = "toggle") ->
	btnToggle = itemField.find(".btnToggleVisiblity")
	txtShow = btnToggle.find(".txtShow")
	txtHide = btnToggle.find(".txtHide")
	inputMasked = itemField.find(".inputMasked")
	inputVisible = itemField.find(".inputVisible")
	btnDropdown = itemField.find(".btn.dropdown-toggle")

	visible = switch visible
		when "toggle" then txtShow.is(":visible")
		when "visible" then true
		when "masked" then false
		else false

	if visible
		txtShow.hide()
		txtHide.show()

		inputVisible.val inputMasked.val()
		global.form.setInputInvalid(inputVisible, global.form.isInputInvalid(inputMasked))

		inputMasked.hide()
		inputVisible.show()
	else
		txtHide.hide()
		txtShow.show()

		inputMasked.val inputVisible.val()
		global.form.setInputInvalid(inputMasked, global.form.isInputInvalid(inputVisible))
		
		inputVisible.hide()
		inputMasked.show()

initBtnToggleVisibility = ->
	$(document).on "click", "#mainList .itemField.itemFieldPassword .btnToggleVisiblity", (e) ->
		itemField = $(this).closest(".itemField")
		setPasswordVisibility(itemField, "toggle")
		return

init = ->
	initBtnOpen()
	initBtnToggleVisibility()

initTemplate = (template) ->
	initBtnCopy(template)

module.exports.init = init
module.exports.initTemplate = initTemplate
module.exports.setPasswordVisibility = setPasswordVisibility
