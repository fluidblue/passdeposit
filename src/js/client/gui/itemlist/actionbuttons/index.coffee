###
# PassDeposit #
itemlist action buttons

Created by Max Geissler
###

tooltips = require "./tooltips"
btndelete = require "./btndelete"
btnduplicate = require "./btnduplicate"
btncancel = require "./btncancel"
btnsave = require "./btnsave"

initTemplate = (template) ->
	tooltips.initTemplate(template)
	btndelete.initTemplate(template)

init = ->
	btnduplicate.init()
	btncancel.init()
	btnsave.init()

module.exports.init = init
module.exports.initTemplate = initTemplate
