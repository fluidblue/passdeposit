/**
 * PassDeposit
 * Exports: initTooltips()
 * 
 * @author Max Geissler
 */

var $ = require('jquery');

function initTooltips()
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

module.exports = initTooltips;