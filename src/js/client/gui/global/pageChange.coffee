###
# PassDeposit #
Page change

Created by Max Geissler
###

duration = 400

change = (pageID, callbackHidden, callbackShown) ->
	hidePage = ".page:not(" + pageID + ")"

	$(hidePage).clearQueue().fadeOut(duration / 2).promise().done ->
		# Show new page
		$(pageID).clearQueue().fadeTo duration / 2, 1, ->
			# Callback after page is completely visible
			if callbackShown?
				callbackShown()

		# Callback after page has been hidden and
		# new page is about to be shown
		if callbackHidden?
			callbackHidden()

		return

module.exports.change = change
