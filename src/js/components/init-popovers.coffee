###
# PassDeposit #
Initialize popovers

Created by Max Geissler
###

initPopovers = ->
	# Nasty fix for repositioning popover on resize
	$(window).resize ->
		if $(".popover").is(":visible")
			popover = $(".popover")
			
			popover.addClass "noTransition"
			$("input:focus").popover "show"
			popover.removeClass "noTransition"

		return

module.exports = initPopovers
