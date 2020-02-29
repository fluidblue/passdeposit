###
# PassDeposit #
Global GUI functions

Created by Max Geissler
###

form = require "./form"
text = require "./text"
banner = require "./banner"
jGrowl = require "./jGrowl"
navPills = require "./navPills"
pageChange = require "./pageChange"
clipboard = require "./clipboard"
inactivity = require "./inactivity"

init = ->
	banner.init()
	navPills.init()
	jGrowl.init()

module.exports.form = form
module.exports.text = text
module.exports.jGrowl = jGrowl
module.exports.navPills = navPills
module.exports.pageChange = pageChange
module.exports.clipboard = clipboard
module.exports.inactivity = inactivity
module.exports.init = init
