###
# PassDeposit #
Global GUI functions

Created by Max Geissler
###

setFormFocus = require "./setFormFocus"
text = require "./text"
jGrowlExtend = require "./jGrowlExtend"
navPills = require "./navPills"

init = ->
	navPills.init()
	jGrowlExtend.init()

module.exports.setFormFocus = setFormFocus
module.exports.text = text
module.exports.jGrowlExtend = jGrowlExtend
module.exports.navPills = navPills
module.exports.init = init
