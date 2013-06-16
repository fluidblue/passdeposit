/**
 * PassDeposit
 * Fields
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('jquery.jGrowl');
var ZeroClipboard = require('../lib/ZeroClipboard');

function init()
{
	ZeroClipboard.setDefaults( { moviePath: 'media/zeroclipboard.swf' } );
	var clip = new ZeroClipboard();
	
	clip.on( 'load', function ( client, args ) {
		// TODO: Remove
		alert( "movie has loaded" );
	});
	
	$('.itemField .btnCopy').click(function()
	{
		var input = $(this).parent().children('input:visible');
		
		// TODO: Not working
		clip.setText(input.val());
		//alert(input.val());
		
		// Show notification
		$.jGrowl($('#text .copiedToClipboard').html());
	});
	
	$('.itemField .btnOpen').click(function()
	{
		var input = $(this).parent().children('input:visible');
		var uri = input.val();
		
		// Cancel if field is empty
		if (uri.length === 0)
			return;
		
		// Append protocol, if not given
		if (uri.indexOf('://') === -1)
			uri = 'http://' + uri;
		
		window.open(uri);
	});
	
	$('.itemField.itemFieldPassword').each(function(i, elem)
	{
		elem = $(elem);
		
		var btnToggle = elem.children('.btnToggleVisiblity');
		var txtShow = btnToggle.children('.txtShow');
		var txtHide = btnToggle.children('.txtHide');
		var inputMasked = elem.children('.inputMasked');
		var inputVisible = elem.children('.inputVisible');
		
		btnToggle.click(function()
		{
			if (txtShow.is(':visible'))
			{
				txtShow.hide();
				txtHide.show();
				
				inputVisible.val(inputMasked.val());
				
				inputMasked.hide();
				inputVisible.show();
			}
			else
			{
				txtHide.hide();
				txtShow.show();
				
				inputMasked.val(inputVisible.val());
				
				inputVisible.hide();
				inputMasked.show();
			}
		});
	});
}

module.exports.init = init;