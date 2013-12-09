###
# PassDeposit #
Set input invalid

Created by Max Geissler
###

setInputInvalid = (jqElem) ->
	jqElem.addClass "invalidInput"
	jqElem.one "keypress", ->
		jqElem.removeClass "invalidInput"
		return

module.exports = setInputInvalid
