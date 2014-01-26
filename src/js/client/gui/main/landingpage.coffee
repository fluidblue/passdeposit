###
# PassDeposit #
itemlist donate wiggle

Created by Max Geissler
###

shared = require "../../../shared"

# Wiggle animation duration is derived
# from CSS3 animation settings + 500ms security gap
wiggleDuration = 5 * 300 + 500

timer = null

setWiggle = (elem, duration, callback) ->
	elem.addClass "wiggle"
	
	setTimeout ->
		elem.removeClass "wiggle"
		callback()
		return
	, duration

startWiggle = (waitTime) ->
	if !waitTime?
		waitTime = shared.util.getRandomInt(3000, 8000)

	timer = setTimeout ->
		# Start wiggling
		setWiggle $("#primaryDonationLink"), wiggleDuration, ->
			# Start over if stopWiggle() has not been called
			if timer then startWiggle()

		return
	, waitTime

stopWiggle = ->
	clearTimeout timer
	timer = null

show = (firstShow) ->
	$("#landingPage").show()

	# Start wiggling, if not yet started
	if !timer
		if firstShow
			startWiggle shared.util.getRandomInt(1000, 3000)
		else
			startWiggle()

hide = ->
	$("#landingPage").hide()

	# Stop wiggling
	stopWiggle()

module.exports.show = show
module.exports.hide = hide
