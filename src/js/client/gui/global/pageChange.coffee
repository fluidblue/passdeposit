###
# PassDeposit #
Page change

Created by Max Geissler
###

pageChangeDuration = 400

change = (pageID, callbackHidden, callbackShow) ->
	hidePage = ".page:not(" + pageID + ")"
	
	$(hidePage).fadeOut pageChangeDuration / 2, ->
		# Callback after page has been hidden
		if callbackHidden?
			callbackHidden()

		# Show new page
		$(pageID).fadeIn pageChangeDuration / 2

		# Immediately callback
		if callbackShow?
			callbackShow()

		return

module.exports.change = change
