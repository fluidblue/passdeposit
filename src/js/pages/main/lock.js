/**
 * PassDeposit
 * Lock dialog
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('bootstrap');
var logout = require('./logout');

function lock()
{
	// TODO: Hide data!
	$('#lockDialog').modal('show');
}

function init()
{
	$('#btnLock').click(function()
	{
		lock();
		return false;
	});
	
	$('#lockDialog').on('shown', function()
	{
		$('#lockDialog input.pass').focus();
	});
	
	$('#lockDialog').submit(function()
	{
		// Remove password
		$('#lockDialog input.pass').val('');
		
		// Close dialog
		$('#lockDialog').modal('hide');

		return false;
	});
	
	$('#lockDialog .btnLogout').click(function()
	{
		// Remove password, if any
		$('#lockDialog input.pass').val('');
		
		// Logout after dialog closes
		$('#lockDialog').on('hidden.logout', function()
		{
			$('#lockDialog').off('hidden.logout');
			logout.logout();
		});
		
		// Close dialog
		$('#lockDialog').modal('hide');

		return false;
	});
}

module.exports.init = init;
module.exports.lock = lock;