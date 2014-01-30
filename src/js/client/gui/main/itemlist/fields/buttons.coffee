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
	btnCopy.on "mouseover", (e) ->
		global.clipboard.activate
			element: this

			dataRequested: (elem) ->
				# Set data to be copied to clipboard
				field = $(elem).closest(".itemField")
				input = field.find("input[type=text]:visible, input[type=password]:visible")
				return input.val()

			mouseover: (elem) ->
				$(elem).addClass("btn-hover")
				return

			mouseout: (elem) ->
				$(elem).removeClass("btn-hover")
				$(elem).removeClass("btn-active")
				$(elem).blur()
				return

			mousedown: (elem) ->
				$(elem).addClass("btn-active")
				return

			mouseup: (elem) ->
				$(elem).removeClass("btn-active")
				return
		
		# Prevent propagation to underlying div
		e.stopPropagation()
		
		return

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

initBtnToggleVisibility = ->
	$(document).on "click", "#mainList .itemField.itemFieldPassword .btnToggleVisiblity", (e) ->
		itemField = $(this).closest(".itemField")

		btnToggle = itemField.find(".btnToggleVisiblity")
		txtShow = btnToggle.find(".txtShow")
		txtHide = btnToggle.find(".txtHide")
		inputMasked = itemField.find(".inputMasked")
		inputVisible = itemField.find(".inputVisible")
		btnDropdown = itemField.find(".btn.dropdown-toggle")

		if txtShow.is(":visible")
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

		return

init = ->
	initBtnOpen()
	initBtnToggleVisibility()

initTemplate = (template) ->
	initBtnCopy(template)

module.exports.init = init
module.exports.initTemplate = initTemplate
