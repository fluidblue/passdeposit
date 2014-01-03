###
# PassDeposit #
Form functions

Created by Max Geissler
###

setInputInvalid = (jqElem, invalid = true) ->
	if invalid
		jqElem.addClass "invalidInput"
		jqElem.one "keypress.invalid change.invalid input.invalid", ->
			setInputInvalid(jqElem, false)
			return
	else
		jqElem.removeClass "invalidInput"
		jqElem.off "keypress.invalid change.invalid input.invalid"

isInputInvalid = (jqElem) ->
	return jqElem.hasClass "invalidInput"

focus = (parentID) ->
	lastInput = null
	
	$(parentID).find("input, textarea").each (i, obj) ->
		obj = $(obj)
		
		# Save last input which is not of type submit or button.
		lastInput = obj unless obj.is(":submit, :button")
		
		# Focus first empty input or invalid input
		if obj.val().length == 0 || obj.hasClass("invalidInput")
			# Focus input
			obj.focus()
			
			# Do not focus again
			lastInput = null
			
			# Exit loop
			return false
		
		# Continue loop
		return true
	
	# Focus last input
	if lastInput
		lastInput.focus()

module.exports.focus = focus
module.exports.setInputInvalid = setInputInvalid
module.exports.isInputInvalid = isInputInvalid
