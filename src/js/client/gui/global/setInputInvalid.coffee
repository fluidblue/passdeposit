###
# PassDeposit #
Set input invalid

Created by Max Geissler
###

setInputInvalid = (jqElem) ->
	jqElem.addClass "invalidInput"
	jqElem.one "keypress.invalid change.invalid input.invalid", ->
		jqElem.removeClass "invalidInput"
		jqElem.off "keypress.invalid change.invalid input.invalid"
		return

module.exports = setInputInvalid
