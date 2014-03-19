###
# PassDeposit #
Image preloader

Created by Max Geissler
###

load = (src) ->
	# Create new image in memory
	(new Image()).src = src

init = ->
	# Preload all images which are not loaded
	# when visiting the front page
	images = [
		"media/social.png"
	]

	for img in images
		load(img)

module.exports.init = init
