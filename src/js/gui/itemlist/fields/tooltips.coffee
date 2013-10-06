###
# PassDeposit #
Field buttons

Created by Max Geissler
###

initTooltipWebAddress = (fieldTemplate) ->
	# Create web address tooltip
	# TODO: Enable animation (Bug when focus already set and bug with arrow)

	options =
		placement: "bottom"
		title: $("#text .infoURI").html()
		trigger: "focus"
		animation: false

	fieldTemplate.find("input[type=text]").tooltip options

initTooltipPassGen = (fieldTemplate) ->
	# Create password generation tooltip
	options =
		placement: "bottom"
		title: $("#text .passGenerated").html()
		trigger: "manual"
		animation: true

	# Create tooltip on both password and text input
	inputMasked = fieldTemplate.find("input[type=password]")
	inputVisible = fieldTemplate.find("input[type=text]")

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

initTooltipPassGenHint = (fieldTemplate) ->
	inputMasked = fieldTemplate.find(".inputMasked")
	inputVisible = fieldTemplate.find(".inputVisible")
	btnDropdown = fieldTemplate.find(".btn.dropdown-toggle")

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

initFieldTemplate = (fieldTemplate, type) ->
	switch type
		when "uri"
			initTooltipWebAddress(fieldTemplate)

		when "pass"
			initTooltipPassGen(fieldTemplate)
			initTooltipPassGenHint(fieldTemplate)

		else return

module.exports.initFieldTemplate = initFieldTemplate
