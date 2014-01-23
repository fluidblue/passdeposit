###
# PassDeposit #
itemlist pagination

Created by Max Geissler
###

global = require "../../global"

pager = null
infoText = null
prev = null
next = null

currentPage = 0
totalPages = 0
callback = null

set = (currentPage_, totalPages_, callback_) ->
	currentPage = currentPage_
	totalPages = totalPages_
	callback = callback_

	update()

update = ->
	# Only show pager if there is more than one page
	if totalPages >= 1
		pager.show()
	else
		pager.hide()
		return

	# Set info text
	info = global.text.get "pagination", currentPage, totalPages
	infoText.html info

	# Enable/Disable prev button
	if currentPage > 0
		prev.removeClass("disabled")
	else
		prev.addClass("disabled")

	# Enable/Disable next button
	if currentPage < totalPages - 1
		next.removeClass("disabled")
	else
		next.addClass("disabled")

init = ->
	pager = $("#pagination")
	infoText = $("#pagination .middle")
	prev = $("#pagination a[href=#prev]").parent()
	next = $("#pagination a[href=#next]").parent()

	$("#pagination a").click (e) ->
		e.preventDefault()

		href = $(this).attr("href")

		if href == "#prev"
			if currentPage <= 0
				return

			currentPage--
		else
			if currentPage >= totalPages - 1
				return

			currentPage++

		update()
		callback(currentPage)

		return

module.exports.set = set
module.exports.init = init
