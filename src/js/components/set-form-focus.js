/**
 * PassDeposit
 * Exports: setFormFocus(parent)
 * 
 * @author Max Geissler
 */

var $ = require('jquery');

module.exports = function(parent)
{
	var lastInput = null;

	$(parent + " input").each(function(i, obj)
	{
		// Save last input which is not of type submit or button.
		if (!$(obj).is(":submit, :button"))
			lastInput = $(obj);

		// Focus first empty input
		if ($(obj).val().length === 0)
		{
			// Focus input
			$(obj).focus();

			// Do not focus again
			lastInput = null;

			// Exit loop
			return false;
		}

		return true;
	});

	if (lastInput)
	{
		// Focus last input
		lastInput.focus();
	}
};