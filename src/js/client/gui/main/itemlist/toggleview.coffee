###
# PassDeposit #
itemlist toggle view

Created by Max Geissler
###

fields = require "./fields"

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

			# Mask password field(s)
			item.find(".itemField.itemFieldPassword").each ->
				fields.setPasswordVisibility($(this), "masked")

				# Continue with loop
				return true
		else
			# Open the item
			item.addClass("open")

			# Fix width of tags
			$(window).triggerHandler("tags-fix-width")

		return

module.exports.init = init
