###
# PassDeposit #
Global GUI functions

Created by Max Geissler
###

form = require "./form"
text = require "./text"
jGrowl = require "./jGrowl"
navPills = require "./navPills"
pageChange = require "./pageChange"

init = ->
	navPills.init()
	jGrowl.init()

module.exports.form = form
module.exports.text = text
module.exports.jGrowl = jGrowl
module.exports.navPills = navPills
module.exports.pageChange = pageChange
module.exports.init = init
