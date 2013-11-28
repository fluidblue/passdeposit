###
# PassDeposit #
Field menu

Created by Max Geissler
###

core = require "../../../core"
field = require "."

up = (elem) ->
	elem.after(elem.prev())
	return

down = (elem) ->
	elem.before(elem.next(":not(.itemFieldTags)"))
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
	input = elem.find("input[type=text]:visible, input[type=password]:visible")

	newField =
		type: type
		value: input.val()

	field.replace(elem, newField)

	return

init = ->
	$(document).on "click", "#mainList .content .menuFieldContext .dropdown-menu a", (e) ->
		e.preventDefault()

		elem = $(this)
		href = elem.attr("href")
		fld = elem.closest(".itemField")

		switch href
			# Handle structure actions
			when "#up" then up(fld)
			when "#down" then down(fld)
			when "#remove" then remove(fld)

			# Handle password generation
			when "#generate" then passgen(fld)
			
			# Prevent closing of menu
			when "#"
				elem.blur()
				e.stopPropagation()
			
			# Handle type change
			else typechange(fld, href.substr(1))

		return

module.exports.init = init
