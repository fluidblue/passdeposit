###
# PassDeposit #
itemlist action button: cancel

Created by Max Geissler
###

init = ->
	$(document).on "click", "#mainList .content .btnCancel", (e) ->
		alert "cancel"
		return

module.exports.init = init
