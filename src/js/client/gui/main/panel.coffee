###
# PassDeposit #
No results page

Created by Max Geissler
###

landingpage = require "./landingpage"

show = (firstShow = false) ->
	if $("#search").val().length > 0
		landingpage.hide()
		$("#noresults").show()
	else
		$("#noresults").hide()
		landingpage.show(firstShow)

hide = ->
	$("#noresults").hide()
	landingpage.hide()

module.exports.show = show
module.exports.hide = hide
