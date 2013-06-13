/**
 * PassDeposit
 * Options dialog
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('bootstrap');

// Initializes option dialog
function init()
{
	var saveOptions = false;
	
	$('#optionsDialog').on('show', function()
	{
		saveOptions = false;
	});
	
	$('#optionsDialog .btnDo').click(function()
	{
		if ($('#optionsDialog .nav-pills a[href=#options-general]').parent().hasClass('active'))
			saveOptions = true;
		
		$('#optionsDialog').modal('hide');
	});
	
	$('#optionsDialog').on('hidden', function()
	{
		if (saveOptions)
			$.jGrowl($('#text .optionsSaved').html());
	});
}

module.exports = init;