/**
 * PassDeposit
 * Exports: initNavPills()
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
var setFormFocus = require('./set-form-focus');

var navPillFadeDuration = 200;

function initNavPills()
{
	// Speed up content change by using mousedown instead of click event.
	$(".nav-pills li a").mousedown(function()
	{
		var parent = $(this).parent();

		// Cancel if already active
		if (parent.hasClass("active"))
			return;

		// Get target (group)
		var target = $(this).parent().parent().attr("data-target");

		// Set nav-pill
		$(".nav-pills[data-target=" + target + "] li").removeClass("active");
		parent.addClass("active");

		// Stop all runnning and queued animations
		var allContent = $("." + target + " .navContent");
		allContent.stop(true, true);

		// Fade old content out, fade new content in and set focus
		var content = $(this).attr('href');
		// TODO: Check removal of promise/done
		allContent.fadeOut(navPillFadeDuration).promise().done(function()
		{
			$(content).fadeIn(navPillFadeDuration);
			setFormFocus(content);
		});
	});

	$(".nav-pills li a").click(function()
	{
		// Suppress link opening
		return false;
	});
};

module.exports = initNavPills;