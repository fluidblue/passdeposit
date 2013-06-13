/**
 * PassDeposit
 * Modal dialogs
 * 
 * @author Max Geissler
 */

var $ = require('jquery');

function closeAll()
{
	$('div.jGrowl-close').each(function()
	{
		$(this).triggerHandler('click');
	});
}

function init()
{
	// Close all jGrowl messages when a modal dialog is opened.
	$('.modal').on('show', function()
	{
		closeAll();
	});
}

module.exports.init = init;
module.exports.closeAll = closeAll;