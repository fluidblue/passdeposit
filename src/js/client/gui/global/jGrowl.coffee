###
# PassDeposit #
JGrowl extensions

Created by Max Geissler
###

show = (text, options = {}) ->
	# Set default life time
	if !options.life?
		options.life = 5000

	$.jGrowl text, options

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
module.exports.show = show
module.exports.closeAll = closeAll
