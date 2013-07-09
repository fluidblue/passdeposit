###
# PassDeposit #
NavPills

Created by Max Geissler
###

require "jquery"
setFormFocus = require "./set-form-focus"

navPillFadeDuration = 200

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
		
		# TODO: Check removal of promise/done
		allContent.fadeOut(navPillFadeDuration).promise().done ->
			$(content).fadeIn navPillFadeDuration
			setFormFocus content
			return

		return

	$(".nav-pills li a").click (e) ->
		# Suppress link opening
		e.preventDefault()
		return

trigger = (navPillID, target) ->
	$(navPillID + " a[href=" + target + "]").triggerHandler "mousedown"

module.exports.init = init
module.exports.trigger = trigger