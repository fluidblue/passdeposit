###
# PassDeposit #
itemlist item id getter and setter

Created by Max Geissler
###

get = (item) ->
	id = item.data("item-id")

	if !id?
		return 0
	else
		return id

set = (item, id) ->
	item.data("item-id", id)

module.exports.get = get
module.exports.set = set
