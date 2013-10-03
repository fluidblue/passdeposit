###
# PassDeposit #
itemlist quick buttons

Created by Max Geissler
###

initTooltips = (template) ->
	buttonContainer = template.find(".header .buttons")

	options =
		placement: "top"
		trigger: "hover focus"
		animation: false

	options.title = $("#text .copyPass").html()
	buttonContainer.find(".btnPass").tooltip options

	options.title = $("#text .openAddress").html()
	buttonContainer.find(".btnOpen").tooltip options

initBtnPass = ->
	$(document).on "click", "#mainList .item .header a.btnPass", (e) ->
		item = $(this).closest(".item")
		passField = item.find(".content .itemFieldPassword")

		inputMasked = passField.find(".inputMasked")
		inputVisible = passField.find(".inputVisible")

		value = if inputMasked.css("display") == "none" then inputVisible.val() else inputMasked.val()

		# TODO: Copy to clipboard
		console.log("copy to clipboard: " + value)

		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		e.preventDefault()
		return

initBtnOpen = ->
	$(document).on "click", "#mainList .item .header a.btnOpen", (e) ->
		elem = $(this)

		item = elem.closest(".item")
		uriField = item.find(".content .itemFieldWebAddress")
		input = uriField.find("input[type=text]")

		# Set correct href
		elem.attr("href", input.val())

		return

initTemplate = (template) ->
	initTooltips(template)

init = ->
	# Add button events
	initBtnPass()
	initBtnOpen()

module.exports.initTemplate = initTemplate
module.exports.init = init
