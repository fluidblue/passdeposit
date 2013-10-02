###
# PassDeposit #
itemlist toggle view

Created by Max Geissler
###

init = ->
	$(document).on "click", "#mainList .header .clickable", (e) ->
		item = $(this).closest(".item")

		# Open or close item
		if item.hasClass("open")
			item.removeClass("open")
		else
			item.addClass("open")

		return

module.exports.init = init
