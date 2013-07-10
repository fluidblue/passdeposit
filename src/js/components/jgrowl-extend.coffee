###
# PassDeposit #
JGrowl extensions

Created by Max Geissler
###

closeAll = ->
	$("div.jGrowl-close").each ->
		$(this).triggerHandler "click"

		# Continue with loop
		return true

init = ->
	# Close all jGrowl messages when a modal dialog is opened.
	$(".modal").on "show", ->
		closeAll()
		return

module.exports.init = init
module.exports.closeAll = closeAll