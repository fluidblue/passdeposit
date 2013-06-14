/**
 * PassDeposit
 * Fields
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
var ZeroClipboard = require('../lib/ZeroClipboard');

function init()
{
	ZeroClipboard.setDefaults( { moviePath: 'media/zeroclipboard.swf' } );
	var clip = new ZeroClipboard();
	
	clip.on( 'load', function ( client, args ) {
		// TODO
		alert( "movie has loaded" );
	});
	
	$('.itemField .btnCopy').click(function()
	{
		var input = $(this).parent().children('input:visible');

		clip.setText(input.val());
		alert(input.val());
	});
	
	$('.itemField .btnOpen').click(function()
	{
		var input = $(this).parent().children('input:visible');
		var url = input.val();
		
		// Append protocol, if not given
		if (url.indexOf('://') === -1)
			url = 'http://' + url;
		
		window.open(url);
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
			// TODO: Not working
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