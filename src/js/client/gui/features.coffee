###
# PassDeposit #
Provide access to server feature settings

Created by Max Geissler
###

core = require "../core"

features = null
subscribers = []

init = ->
	core.user.features (response) ->
		if response.status == "success"
			features = response
		else
			features = {}

		while subscribers.length > 0
			callback = subscribers.pop()
			callback(features)

get = (callback) ->
	if features != null
		callback(features)
	else
		subscribers.push(callback)

module.exports.init = init
module.exports.get = get
