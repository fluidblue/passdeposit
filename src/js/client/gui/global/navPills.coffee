###
# PassDeposit #
NavPills

Created by Max Geissler
###

form = require "./form"

navPillFadeDuration = 400

init = ->
	# Speed up content change by using mousedown instead of click event.
	$(".nav-pills li:not(.dropdown) > a").mousedown ->
		that = $(this)
		parent = that.parent()
		content = that.attr("href")
		callback = that.data("callback")

		# Cancel if already active
		if $(content).is(":visible")
			return

		isDropdownMenuItem = that.closest("ul").hasClass("dropdown-menu")
		navPill = if isDropdownMenuItem then that.closest("li.dropdown") else parent
		
		# Get container
		container = that.closest(".nav-pills")

		# Set active nav-pill
		container.find("li").removeClass "active"
		navPill.addClass "active"
		
		# Stop all runnning and queued animations
		target = container.attr("data-target")
		allContent = $("." + target + " .navContent")
		allContent.stop true, true
		
		# Fade old content out
		allContent.fadeOut(navPillFadeDuration / 2).promise().done ->
			# Fire callback
			if callback?
				callback(content)

			# Fade new content in and set focus
			$(content).fadeIn navPillFadeDuration / 2
			form.focus content
			return

		return

	$(".nav-pills li:not(.dropdown) > a").click (e) ->
		parent = $(this).parent()

		# Suppress link opening
		e.preventDefault()
		return

change = (navPillID, content, animation) ->
	if animation
		$(navPillID + " a[href=" + content + "]").triggerHandler "mousedown"
		return

	# Get target (group)
	target = $(navPillID).attr("data-target")

	# Get all links
	links = $(navPillID + " li a")

	links.each ->
		elem = $(this)
		parent = $(this).parent()

		# Set nav-pill
		if elem.attr("href") == content
			parent.addClass "active"
		else
			parent.removeClass "active"

		# Continue with loop
		return true

	links.promise().done ->
		# Hide old content, show new content and set focus
		$("." + target + " .navContent").hide()
		$(content).show()
		form.focus content

module.exports.init = init
module.exports.change = change
