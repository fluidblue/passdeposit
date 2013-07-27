###
# PassDeposit #
Field buttons

Created by Max Geissler
###

clipboard = require "../clipboard"
generatePassword = require "../../../core/passgen"

init = ->
	$(".itemField .btnCopy").click ->
		input = $(this).parent().children("input[type=text]")
		
		# Copy to clipboard
		clipboard.setText input.val()
		
		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		return

	# Create web address tooltip
	options =
		placement: "bottom"
		title: $("#text .emptyURI").html()
		trigger: "manual"

	$(".itemField.itemFieldWebAddress input[type=text]").tooltip options

	$(".itemField.itemFieldWebAddress .btnOpen").click ->
		input = $(this).parent().children("input[type=text]")
		uri = input.val()
		
		# Cancel if field is empty
		if uri.length == 0
			# Show notification
			fnShow = ->
				input.tooltip "show"
			
			# Hide notification when losing focus or typing text
			fnHide = ->
				input.tooltip "hide"
				input.off "blur.tooltip"
				input.off "keydown.tooltip"

			input.one "focus.tooltip", fnShow
			input.one "blur.tooltip", fnHide
			input.one "keydown.tooltip", fnHide
		
			# Set focus
			input.focus()
			return
		
		# Append http protocol, if not given
		if uri.indexOf("://") == -1
			uri = "http://" + uri

		window.open uri

		return

	$(".itemField.itemFieldPassword .dropdown-menu a[href=#generate]").click (e) ->
		input = $(this).closest(".itemField.itemFieldPassword").find("input:visible")
		input.val generatePassword()

		# TODO: Show tooltip notification

		e.preventDefault()
		return

	$(".itemField.itemFieldPassword").each (i, elem) ->
		elem = $(elem)

		btnToggle = elem.children(".btnToggleVisiblity")
		txtShow = btnToggle.children(".txtShow")
		txtHide = btnToggle.children(".txtHide")
		inputMasked = elem.children(".inputMasked")
		inputVisible = elem.children(".inputVisible")
		btnDropdown = elem.find(".btn.dropdown-toggle")

		# Create password generation hint
		options =
			placement: "bottom"
			title: $("#text .passGenerationHint").html()
			trigger: "manual"

		fnShowTooltip = ->
			btnDropdown.tooltip "show"
			return

		fnHideTooltip = ->
			btnDropdown.tooltip "hide"
			return

		btnDropdown.tooltip options

		inputMasked.focus fnShowTooltip
		inputVisible.focus fnShowTooltip

		inputMasked.blur fnHideTooltip
		inputVisible.blur fnHideTooltip
		
		btnToggle.click ->
			if txtShow.is(":visible")
				txtShow.hide()
				txtHide.show()

				inputVisible.val inputMasked.val()

				inputMasked.hide()
				inputVisible.show()
			else
				txtHide.hide()
				txtShow.show()

				inputMasked.val inputVisible.val()
				
				inputVisible.hide()
				inputMasked.show()

		# Continue with loop
		return true

module.exports.init = init
