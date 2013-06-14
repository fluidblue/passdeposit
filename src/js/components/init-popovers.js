/**
 * PassDeposit
 * Exports: initPopovers()
 * 
 * @author Max Geissler
 */

var $ = require('jquery');

function initPopovers()
{
	// Nasty fix for repositioning popover on resize
	$(window).resize(function()
	{
		if ($('.popover').is(':visible'))
		{
			var popover = $('.popover');
			popover.addClass('noTransition');
			$('input:focus').popover('show');
			popover.removeClass('noTransition');
		}
	});
}

module.exports = initPopovers;