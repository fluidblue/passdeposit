###
# PassDeposit #
mainList

Created by Max Geissler
###

clipboard = require "./clipboard"
core = require "../../core"

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

	$(document).on "click", "#mainList .content .btnSave", ->
		item = $(this).closest(".item")

		# Get fields
		fields = new Array()

		item.find(".itemField").each (i, elem) ->
			elem = $(elem)

			# Get value
			value = elem.find("input[type=text]:visible, input[type=password]:visible").val()

			# Get type
			type = "text"
			if elem.hasClass("itemFieldEmail")
				type = "email"
			else if elem.hasClass("itemFieldPassword")
				type = "pass"
			else if elem.hasClass("itemFieldServiceName")
				type = "service"
			else if elem.hasClass("itemFieldWebAddress")
				type = "uri"
			else if elem.hasClass("itemFieldUser")
				type = "user"

			# Add to array
			fields.push
				"type": type
				"value": value
			
			# Continue with loop
			return true
		
		# Get tags
		tags = new Array()

		for tag in item.find(".input-tag").val().split(",")
			tag = $.trim(tag)
			tags.push tag

		# Create item object
		itemObj =
			"fields": fields
			"tags": tags

		# Process item
		id = item.data("item-id")
		exist = id? && id != 0

		if exist
			itemObj.id = id
			core.item.modify(itemObj)
		else
			core.item.add(itemObj)

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

	$("#mainList .header .buttons a.btnPass").click (e) ->
		# TODO
		clipboard.setText "test"

		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		e.preventDefault()
		return

	$("#mainList .header .clickable").click (e) ->
		item = $(this).closest(".item")

		if item.hasClass("open")
			# Close item
			item.find(".content").css("display", "none")
			item.removeClass("open")
		else
			# Open item
			item.addClass("open")
			item.find(".content").css("display", "block")

		return

	initActionButtons()

module.exports.init = init
