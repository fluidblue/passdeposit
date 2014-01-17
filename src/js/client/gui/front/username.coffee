###
# PassDeposit #
Login tab

Created by Max Geissler
###

load = ->
	username = $.totalStorage("username")
	$("#loginUser").val username
	return username

save = (username = null) ->
	if username?
		$("#loginUser").val username

	$.totalStorage "username", $("#loginUser").val()

module.exports.load = load
module.exports.save = save
