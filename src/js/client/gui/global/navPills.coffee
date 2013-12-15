###
# PassDeposit #
NavPills

Created by Max Geissler
###

setFormFocus = require "./setFormFocus"

navPillFadeDuration = 400

init = ->
	# Speed up content change by using mousedown instead of click event.
	$(".nav-pills li a").mousedown ->
		parent = $(this).parent()
		
		# Cancel if already active
		if parent.hasClass("active")
			return
		
		# Get target (group)
		target = $(this).parent().parent().attr("data-target")
		
		# Set nav-pill
		$(".nav-pills[data-target=" + target + "] li").removeClass "active"
		parent.addClass "active"
		
		# Stop all runnning and queued animations
		allContent = $("." + target + " .navContent")
		allContent.stop true, true
		
		# Fade old content out, fade new content in and set focus
		content = $(this).attr("href")
		
		allContent.fadeOut(navPillFadeDuration / 2).promise().done ->
			$(content).fadeIn navPillFadeDuration / 2
			setFormFocus content
			return

		return

	$(".nav-pills li a").click (e) ->
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
		setFormFocus content

module.exports.init = init
module.exports.change = change
