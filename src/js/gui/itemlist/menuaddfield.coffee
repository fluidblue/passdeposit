###
# PassDeposit #
itemlist add field menu

Created by Max Geissler
###

field = require "./field"

init = ->
	$(document).on "click", "#mainList .content .menuAddField .dropdown-menu a", (e) ->
		# Get command
		href = $(this).attr("href")

		# Cut # symbol to get field type
		fieldType = href.substr(1)

		# Create field
		newField =
			type: fieldType
			value: ""

		# Add field
		item = $(this).closest(".item")
		itemFieldContainer = field.getContainer(item)
		field.add(itemFieldContainer, newField)

		e.preventDefault()
		return

module.exports.init = init
