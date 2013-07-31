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
	# TODO: Use selector
	# TODO: Enable animation (Bug when focus already set and bug with arrow)
	options =
		placement: "bottom"
		title: $("#text .infoURI").html()
		trigger: "focus"
		animation: false

	$(".itemField.itemFieldWebAddress input[type=text]").tooltip options

	$(".itemField.itemFieldWebAddress .btnOpen").click ->
		input = $(this).parent().children("input[type=text]")
		uri = input.val()
		
		# Cancel if field is empty
		if uri.length == 0
			# TODO: Testing
			# input.on "hidden.bs.tooltip", ->
			# 	console.log "test"
			# 	return

			# Show notification
			input.attr("data-original-title", $("#text .emptyURI").html()).tooltip("fixTitle")

			# Restore original tooltip
			input.one "blur.tooltipRestore", ->
				input.attr("data-original-title", $("#text .infoURI").html()).tooltip("fixTitle")
				input.off "keydown.tooltipRestore"

			input.one "keydown.tooltipRestore", ->
				input.attr("data-original-title", $("#text .infoURI").html()).tooltip("fixTitle")
				input.off "blur.tooltipRestore"
				input.tooltip("show")
			
			# Set focus
			input.focus()

			return
		
		# Append http protocol, if not given
		if uri.indexOf("://") == -1
			uri = "http://" + uri

		window.open uri

		return

	# Create password generation tooltip
	# TODO: Use selector
	options =
		placement: "bottom"
		title: $("#text .passGenerated").html()
		trigger: "manual"
		animation: true

	# Create tooltip on both the password and text input.
	# Also assign focus function to hide tooltip
	$(".itemField.itemFieldPassword input[type=password]").tooltip(options).focus ->
		$(this).tooltip("hide")
		return

	$(".itemField.itemFieldPassword input[type=text]").tooltip(options).focus ->
		$(this).tooltip("hide")
		return

	$(".itemField.itemFieldPassword .dropdown-menu a[href=#generate]").click (e) ->
		elem = $(this).closest(".itemField.itemFieldPassword")
		input = elem.find("input[type=password]:visible, input[type=text]:visible")
		input.val generatePassword()

		# Show tooltip notification
		input.tooltip("show")

		# Cancel timeout of previous notifications
		oldTimeoutID = elem.data("tooltipTimeoutID")
		if oldTimeoutID?
			window.clearTimeout oldTimeoutID

		# Set timeout to hide the tooltip automatically
		newTimeoutID = window.setTimeout ->
			input.tooltip("hide")
			elem.data("tooltipTimeoutID", null)
			return
		, 3000

		# Save new timeout ID
		elem.data "tooltipTimeoutID", newTimeoutID

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
