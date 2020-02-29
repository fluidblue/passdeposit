###
# PassDeposit #
Enable or disable banner according to server setting

Created by Max Geissler
###

features = require "../features"

init = ->
	# Banner is disabled by default.
	# Enable banner only if set on server.

	features.get (features) ->
		if features.banner
			# Enable banner
			$("#banner").show()

module.exports.init = init
