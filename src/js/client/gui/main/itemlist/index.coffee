###
# PassDeposit #
itemlist manipulations

Created by Max Geissler
###

mainlist = require "./mainlist"
pagination = require "./pagination"

items = []
page = 0
itemsPerPage = 10

defaultAddOptions =
	open: false
	position: "bottom"
	focus: false

add = (item, options = null) ->
	# Merge options
	options = $.extend(true, {}, defaultAddOptions, options)

	mainlist.add(item, options)

remove = (item) ->
	mainlist.remove(item)

replace = (item, newItem, options = {}) ->
	mainlist.replace(item, newItem, options)

clear = (all = false) ->
	mainlist.clear(all)

paginationCallback = (p) ->
	page = p
	# TODO

getNumPages = ->
	return Math.ceil(items.length / itemsPerPage)

init = ->
	mainlist.init()
	pagination.init()

module.exports.add = add
module.exports.remove = remove
module.exports.replace = replace
module.exports.clear = clear
module.exports.init = init
