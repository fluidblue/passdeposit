###
# PassDeposit #
Field menu

Created by Max Geissler
###

core = require "../../../../core"

up = (elem) ->
	console.log("up")
	return

down = (elem) ->
	console.log("down")
	return

remove = (elem) ->
	elem.remove()
	return

passgen = (elem) ->
	input = elem.find("input[type=text]:visible, input[type=password]:visible")
	input.val core.passgen.generatePassword()

	# Show tooltip notification
	input.tooltip("show")

	# Hide tooltip of hidden input
	elem.find("input[type=text]:hidden, input[type=password]:hidden").tooltip("hide")

	# Cancel timeout of previous notifications
	oldTimeoutID = input.data("tooltipTimeoutID")
	if oldTimeoutID?
		window.clearTimeout oldTimeoutID

	# Set timeout to hide the tooltip automatically
	newTimeoutID = window.setTimeout ->
		input.tooltip("hide")
		input.data("tooltipTimeoutID", null)
		return
	, 3000

	# Save new timeout ID
	input.data "tooltipTimeoutID", newTimeoutID
	
	return

typechange = (elem, type) ->
	console.log("typechange: " + type)
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

			# Handle password generation
			when "#generate" then passgen(field)
			
			# Prevent closing of menu
			when "#"
				elem.blur()
				e.stopPropagation()
			
			# Handle type change
			else typechange(field, href.substr(1))

		e.preventDefault()
		return

module.exports.init = init
