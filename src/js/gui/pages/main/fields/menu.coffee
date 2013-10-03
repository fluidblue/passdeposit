###
# PassDeposit #
Field menu

Created by Max Geissler
###

up = (field) ->
	console.log("up")
	return

down = (field) ->
	console.log("down")
	return

remove = (field) ->
	console.log("remove")
	return

init = ->
	$(document).on "click", "#mainList .content .menuFieldContext .dropdown-menu a", (e) ->
		elem = $(this)
		href = elem.attr("href")
		field = elem.closest(".itemField")

		switch href
			# Handle structure actions
			when "#up" then up(field)
			when "#down" then down(field)
			when "#remove" then remove(field)

			# Handle type change
			# TODO
			
			# Prevent closing of menu
			when "#"
				elem.blur()
				e.stopPropagation()
			
			# Leave other menu items to other handlers
			else return

		e.preventDefault()
		return

module.exports.init = init
