###
# PassDeposit #
itemlist item id getter and setter

Created by Max Geissler
###

get = (item) ->
	id = item.data("item-id")

	if !id?
		return null
	else
		return id

set = (item, id) ->
	if !id?
		id = null

	item.data("item-id", id)

module.exports.get = get
module.exports.set = set
