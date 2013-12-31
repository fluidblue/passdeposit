###
# PassDeposit #
Field buttons

Created by Max Geissler
###

format = require "../format"
global = require "../../../global"

initBtnCopy = ->
	$(document).on "click", "#mainList .itemField .btnCopy", (e) ->
		field = $(this).closest(".itemField")
		input = field.find("input[type=text]:visible, input[type=password]:visible")
		
		# Copy text to clipboard
		global.clipboard.setText input.val()

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
	initBtnCopy()
	initBtnOpen()
	initBtnToggleVisibility()

module.exports.init = init
