###
# PassDeposit #
itemlist add field menu

Created by Max Geissler
###

fields = require "./fields"

init = ->
	$(document).on "click", "#mainList .content .menuAddField .dropdown-menu a", (e) ->
		e.preventDefault()

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
		itemFieldContainer = fields.getContainer(item)
		elem = fields.add(itemFieldContainer, newField)

		# Focus
		elem.find("input[type=password], input[type=text]").focus()

		return

module.exports.init = init
