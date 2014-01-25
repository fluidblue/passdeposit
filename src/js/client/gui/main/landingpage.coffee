###
# PassDeposit #
itemlist donate wiggle

Created by Max Geissler
###

shared = require "../../../shared"

donateLink = null
timer = null

wiggle = (elem, duration, callback) ->
	elem.wiggle()

	setTimeout ->
		elem.wiggle "stop"
		callback()
		return
	, duration

startWiggle = (waitTime) ->
	if !waitTime?
		waitTime = shared.util.getRandomInt(3000, 8000)

	timer = setTimeout ->
		hover = $("#primaryDonationLink:hover").length > 0

		# Start wiggling if element is not hovered.
		if hover? && !hover
			wiggle donateLink, 1200, ->
				# Start over if hide() has not been called
				if timer then startWiggle()
		else
			# Try again later if hide() has not been called
			if timer then startWiggle()

		return
	, waitTime

stopWiggle = ->
	clearTimeout timer
	timer = null

show = (firstShow) ->
	$("#landingpage").show()

	# Start wiggling, if not yet started
	if !timer
		if firstShow
			startWiggle shared.util.getRandomInt(1000, 3000)
		else
			startWiggle()

hide = ->
	$("#landingpage").hide()

	# Stop wiggling
	stopWiggle()

init = ->
	donateLink = $("#primaryDonationLink")
	donateLink.css("display", "inline-block")

	donateLink.hover ->
		# Stop wiggling when hovering element
		donateLink.wiggle "stop"

module.exports.show = show
module.exports.hide = hide
module.exports.init = init
