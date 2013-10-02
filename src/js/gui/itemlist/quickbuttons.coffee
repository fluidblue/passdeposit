###
# PassDeposit #
itemlist quick buttons

Created by Max Geissler
###

initTemplate = (template) ->
	# Add tooltips
	options =
		placement: "top"
		trigger: "hover focus"
		animation: false

	options.title = $("#text .copyPass").html()
	template.find(".header .buttons a.btnPass").tooltip options

	options.title = $("#text .openAddress").html()
	template.find(".header .buttons a.btnOpen").tooltip options

	# Add button event
	template.find(".header .buttons a.btnPass").click (e) ->
		# TODO: Copy text to clipboard

		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		e.preventDefault()
		return

module.exports.initTemplate = initTemplate
