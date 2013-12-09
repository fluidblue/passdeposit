###
# PassDeposit #
Login tab

Created by Max Geissler
###

load = ->
	$("#loginUser").val $.totalStorage("username")

save = ->
	$.totalStorage "username", $("#loginUser").val()

module.exports.load = load
module.exports.save = save
