###
# PassDeposit #
Field buttons

Created by Max Geissler
###

clipboard = require "../clipboard"
generatePassword = require "../../../core/passgen"

initBtnCopy = ->
	$(".itemField .btnCopy").click ->
		input = $(this).parent().children("input[type=text]")
		
		# Copy to clipboard
		clipboard.setText input.val()
		
		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		return

initTooltipWebAddress = ->
	# Create web address tooltip
	# TODO: Use selector
	# TODO: Enable animation (Bug when focus already set and bug with arrow)
	options =
		placement: "bottom"
		title: $("#text .infoURI").html()
		trigger: "focus"
		animation: false

	$(".itemField.itemFieldWebAddress input[type=text]").tooltip options

initBtnOpen = ->
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

initTooltipPassGen = ->
	# Create password generation tooltip
	# TODO: Use selector
	options =
		placement: "bottom"
		title: $("#text .passGenerated").html()
		trigger: "manual"
		animation: true

	# Create tooltip on both password and text input
	inputMasked = $(".itemField.itemFieldPassword input[type=password]")
	inputVisible = $(".itemField.itemFieldPassword input[type=text]")

	inputMasked.tooltip options
	inputVisible.tooltip options

	# Hide tooltip on focus
	inputMasked.focus ->
		$(this).tooltip("hide")
		return

	inputVisible.focus ->
		$(this).tooltip("hide")
		return

initMenuBtnPassGen = ->
	$(".itemField.itemFieldPassword .dropdown-menu a[href=#generate]").click (e) ->
		elem = $(this).closest(".itemField.itemFieldPassword")
		input = elem.find("input[type=password]:visible, input[type=text]:visible")
		input.val generatePassword()

		# Show tooltip notification
		input.tooltip("show")

		# Cancel timeout of previous notifications
		oldTimeoutID = input.data("tooltipTimeoutID")
		if oldTimeoutID?
			window.clearTimeout oldTimeoutID

		# Set timeout to hide the tooltip automatically
		newTimeoutID = window.setTimeout ->
			input.tooltip("hide")
			input.data("tooltipTimeoutID", null)
			return
		, 3000

		# Save new timeout ID
		input.data "tooltipTimeoutID", newTimeoutID

		e.preventDefault()
		return

initTooltipPassGenHint = ->
	$(".itemField.itemFieldPassword").each (i, elem) ->
		elem = $(elem)

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
		
		# Continue with loop
		return true

initBtnToggleVisibility = ->
	$(".itemField.itemFieldPassword").each (i, elem) ->
		elem = $(elem)

		btnToggle = elem.children(".btnToggleVisiblity")
		txtShow = btnToggle.children(".txtShow")
		txtHide = btnToggle.children(".txtHide")
		inputMasked = elem.children(".inputMasked")
		inputVisible = elem.children(".inputVisible")
		btnDropdown = elem.find(".btn.dropdown-toggle")

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

init = ->
	initBtnCopy()
	initTooltipWebAddress()
	initBtnOpen()
	initTooltipPassGen()
	initMenuBtnPassGen()
	initTooltipPassGenHint()
	initBtnToggleVisibility()

module.exports.init = init
