###
# PassDeposit #
URI auto completion

Created by Max Geissler
###

format = require "../format"

init = ->
	$(document).on "blur", "#mainList .content .itemFieldWebAddress input[type=text]", (e) ->
		input = $(this)

		value = input.val()

		if value.length > 0
			validUri = format.validUri(value)
			input.val(validUri)
		
		return

module.exports.init = init
