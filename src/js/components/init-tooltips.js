/**
 * PassDeposit
 * Exports: initTooltips()
 * 
 * @author Max Geissler
 */

var $ = require('jquery');

function initTooltips()
{
	var fnContent = function()
	{
		return $('.tooltip[data-owner=' + $(this).attr('id') + ']').html();
	};

	var options =
	{
		trigger: 'focus',
		placement: 'right',
		html: true,
		content: fnContent
	};

	$('#registerEmail').popover(options);
	$('#registerPass').popover(options);
	$('#registerPassHint').popover(options);

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