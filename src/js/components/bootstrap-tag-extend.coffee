###
# PassDeposit #
Extend bootstrap-tag

Created by Max Geissler
###

#TODO: MODULE UNUSED!

require "../lib/bootstrap"
require "../lib/bootstrap-tag"

setWidth = (element) ->
	# Container has class .tags
	container = $(element)
	input = container.children("input[type=text]")
	lastTag = container.children(".tag:last")

	fullWidth = container.width()
	newWidth = fullWidth

	if lastTag.length
		lastTagLeft = lastTag.position().left
		lastTagWidth = lastTag.outerWidth()
		newWidth -= (lastTagLeft + lastTagWidth)
		
		# Check min-width
		minWidth = parseInt(input.css("min-width"))
		if minWidth > 0 && newWidth < minWidth
			newWidth = fullWidth

	input.width newWidth

setAllWidth = ->
	$(".tags").each (index, element) ->
		setWidth element

		# Continue with loop
		return true


$(window).resize setAllWidth
setAllWidth()

module.exports.setWidth = setWidth