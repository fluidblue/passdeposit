###
# PassDeposit #
itemlist action button tooltips

Created by Max Geissler
###

text = require "../../../global/text"

initTemplate = (template) ->
	# Add tooltips for delete and duplicate buttons
	options =
		placement: "bottom"
		trigger: "hover focus"
		animation: false
		container: template # Avoid jumping buttons (preserve btn-group)

	options.title = text.get("tooltipDelete")
	template.find(".content .actionButtons .btnDelete").tooltip options

	options.title = text.get("tooltipDuplicate")
	template.find(".content .actionButtons .btnDuplicate").tooltip options

module.exports.initTemplate = initTemplate
