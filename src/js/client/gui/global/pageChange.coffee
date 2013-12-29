###
# PassDeposit #
Page change

Created by Max Geissler
###

duration = 400

change = (pageID, callbackHidden, callbackShow) ->
	hidePage = ".page:not(" + pageID + ")"

	$(hidePage).stop(true, false).fadeOut(duration / 2).promise().done ->
		# Callback after page has been hidden
		if callbackHidden?
			callbackHidden()

		# Show new page
		$(pageID).stop(true, false).fadeTo duration / 2, 1

		# Immediately callback
		if callbackShow?
			callbackShow()

		return

module.exports.change = change
