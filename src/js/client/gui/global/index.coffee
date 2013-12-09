###
# PassDeposit #
Global GUI functions

Created by Max Geissler
###

setFormFocus = require "./setFormFocus"
text = require "./text"
jGrowl = require "./jGrowl"
navPills = require "./navPills"
pageChange = require "./pageChange"

init = ->
	navPills.init()
	jGrowl.init()

module.exports.setFormFocus = setFormFocus
module.exports.text = text
module.exports.jGrowl = jGrowl
module.exports.navPills = navPills
module.exports.pageChange = pageChange
module.exports.init = init
