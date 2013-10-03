###
# PassDeposit #
itemlist toggle view

Created by Max Geissler
###

quickbuttons = require "./quickbuttons"
fields = require "./fields"
format = require "./format"

init = ->
	$(document).on "click", "#mainList .header .clickable", (e) ->
		item = $(this).closest(".item")

		# Open or close item
		if item.hasClass("open")
			# Close the item
			item.removeClass("open")

			# Close delete button popover
			item.find(".popover").css("display", "none")
			item.find(".content .actionButtons .btnDelete").popover("hide")

			# Update quickbuttons
			quickbuttons.setButtons(item)

			# Update title
			fieldList = fields.getFields(item)
			title = format.title(fieldList)
			item.find(".header .title").html(title)
		else
			# Open the item
			item.addClass("open")

		return

module.exports.init = init
