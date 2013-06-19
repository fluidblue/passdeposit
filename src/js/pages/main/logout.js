/**
 * PassDeposit
 * Logout functions
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('bootstrap');
var setFormFocus = require('../../components/set-form-focus');
var jGrowl = require('../../components/jgrowl-extend');
var config = require('../../components/config');

function logout()
{
	// TODO: Clean up data!
	
	// Close all jGrowl messages
	jGrowl.closeAll();
	
	// Switch to frontpage
	$('#mainpage').fadeOut(config.animations.pageChangeDuration, function()
	{
		$('#frontpage').fadeIn(config.animations.pageChangeDuration);
		setFormFocus('#login');
	});
}

function init()
{
	$('#btnLogout').click(function()
	{
		logout();
		return false;
	});
}

module.exports.init = init;
module.exports.logout = logout;