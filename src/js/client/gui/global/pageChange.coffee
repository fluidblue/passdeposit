###
# PassDeposit #
Page change

Created by Max Geissler
###

duration = 400

change = (pageID, callbackHidden, callbackShow) ->
	hidePage = ".page:not(" + pageID + ")"

	$(hidePage).clearQueue().fadeOut(duration / 2).promise().done ->
		# Callback after page has been hidden
		if callbackHidden?
			if !callbackHidden()
				# Cancel if callback returned false
				return

		# Show new page
		$(pageID).clearQueue().fadeTo duration / 2, 1

		# Callback after new page is about to be shown
		if callbackShow?
			callbackShow()

		return

module.exports.change = change
