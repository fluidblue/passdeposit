###
# PassDeposit #
mainList

Created by Max Geissler
###

clipboard = require "./clipboard"

init = ->
	# Add tooltips
	options =
		placement: "top"
		title: $("#text .copyPass").html()
		trigger: "hover"
		animation: false
		#selector: "#mainList .header .buttons a"
	
	# TODO
	#$("body").tooltip options
	$("#mainList .header .buttons a.btnPass").tooltip options

	options.title = $("#text .openAddress").html()
	$("#mainList .header .buttons a.btnOpen").tooltip options

	# Add functionality
	$("#mainList .header .buttons a.btnPass").click (e) ->
		# TODO
		clipboard.setText "test"

		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		e.preventDefault()
		return

	# Add tooltips for delete and duplicate buttons
	options =
		placement: "top"
		trigger: "hover"
		animation: false

	options.title = $("#text .tooltipDelete").html()
	$("#mainList .content .actionButtons .btnDelete").tooltip options

	options.title = $("#text .tooltipDuplicate").html()
	$("#mainList .content .actionButtons .btnDuplicate").tooltip options

module.exports.init = init
