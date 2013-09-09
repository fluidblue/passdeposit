###
# PassDeposit #
mainList

Created by Max Geissler
###

clipboard = require "./clipboard"

initActionButtons = ->
	# Add tooltips for delete and duplicate buttons
	options =
		placement: "bottom"
		trigger: "hover focus"
		animation: false
		container: "body" # Avoid jumping buttons

	options.title = $("#text .tooltipDelete").html()
	$("#mainList .content .actionButtons .btnDelete").tooltip options

	options.title = $("#text .tooltipDuplicate").html()
	$("#mainList .content .actionButtons .btnDuplicate").tooltip options

	# Add popover for delete button
	options =
		trigger: "manual"
		placement: "bottom"
		html: true
		content: $("#text .popoverDeleteContent").html()
		title: $("#text .popoverDeleteTitle").html()
		container: "body" # Avoid jumping butttons

	popover = $("#mainList .content .actionButtons .btnDelete").popover options

	$(document).on "click", "#mainList .content .actionButtons .btnDelete", ->
		$(this).tooltip("hide")
		$(this).popover("show")
		return

	$(document).on "click", ".popover .btnCancelDelete", ->
		popover.popover("hide")
		return

	$(document).on "click", ".popover .btnConfirmDelete", ->
		alert "Deleted."
		popover.popover("hide")
		return

init = ->
	# Add tooltips
	options =
		placement: "top"
		title: $("#text .copyPass").html()
		trigger: "hover focus"
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

	initActionButtons()

module.exports.init = init
