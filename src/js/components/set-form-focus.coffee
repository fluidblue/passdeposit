###
# PassDeposit #
Exports: setFormFocus(parent)

Created by Max Geissler
###

require "jquery"

setFormFocus = (parent) ->
	lastInput = null
	
	$(parent + " input").each (i, obj) ->
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

module.exports = setFormFocus