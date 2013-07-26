###
# PassDeposit #
Field buttons

Created by Max Geissler
###

clipboard = require "../clipboard"
generatePassword = require "../../../core/passgen"

init = ->
	$(".itemField .btnCopy").click ->
		input = $(this).parent().children("input:visible")
		
		# Copy to clipboard
		clipboard.setText input.val()
		
		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		return

	$(".itemField .btnOpen").click ->
		input = $(this).parent().children("input:visible")
		uri = input.val()
		
		# Cancel if field is empty
		if uri.length == 0
			# Create notification
			options =
				placement: "bottom"
				title: $("#text .emptyURI").html()
				trigger: "focus"

			input.tooltip options
			
			# Destroy notification when losing focus or typing text
			fnDestroy = ->
				$(this).tooltip "destroy"

			input.one "blur", fnDestroy
			input.one "keydown", fnDestroy
			
			# Show notification
			input.focus()
			return
		
		# Append protocol, if not given
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
