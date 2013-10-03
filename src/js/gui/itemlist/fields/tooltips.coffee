###
# PassDeposit #
Field buttons

Created by Max Geissler
###

initTooltipWebAddress = ->
	# Create web address tooltip
	# TODO: Enable animation (Bug when focus already set and bug with arrow)

	options =
		placement: "bottom"
		title: $("#text .infoURI").html()
		trigger: "focus"
		animation: false

	$(".itemField.itemFieldWebAddress").each (i, elem) ->
		$(elem).find("input[type=text]").tooltip options
		
		# Continue with loop
		return true

initTooltipPassGen = ->
	# Create password generation tooltip

	options =
		placement: "bottom"
		title: $("#text .passGenerated").html()
		trigger: "manual"
		animation: true

	$(".itemField.itemFieldPassword").each (i, elem) ->
		# Create tooltip on both password and text input
		inputMasked = $(elem).find("input[type=password]")
		inputVisible = $(elem).find("input[type=text]")

		inputMasked.tooltip options
		inputVisible.tooltip options

		# Hide tooltip on focus
		inputMasked.focus ->
			inputMasked.tooltip("hide")
			inputVisible.tooltip("hide")
			return

		inputVisible.focus ->
			inputMasked.tooltip("hide")
			inputVisible.tooltip("hide")
			return
		
		# Continue with loop
		return true

initTooltipPassGenHint = ->
	$(".itemField.itemFieldPassword").each (i, elem) ->
		elem = $(elem)

		inputMasked = elem.find(".inputMasked")
		inputVisible = elem.find(".inputVisible")
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

init = ->
	initTooltipWebAddress()
	initTooltipPassGen()
	initTooltipPassGenHint()

module.exports.init = init
