/**
 * PassDeposit
 * Front page initialization
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('jquery.totalStorage');
require('bootstrap');
require('jquery.jGrowl');
var setFormFocus = require('../components/set-form-focus');
var config = require('../components/config');
var navPills = require('../components/nav-pills');

function loadUsername()
{
	$('#loginUser').val($.totalStorage('username'));
}

function saveUsername()
{
	$.totalStorage('username', $('#loginUser').val());
}

function loginUser()
{
	// Dismiss registration notification(s), if open
	$('div.jGrowl-close').each(function()
	{
		$(this).triggerHandler('click');
	});
	
	if ($('#loginPass').val().length === 0)
	{
//			$('#loginPass').addClass('invalidInput');
//			return false;
	}

	/*$.post('passdeposit.php',
		{
			userName : this.userName,
			pass: this.passHash
		}
	);*/

	saveUsername();

	// Switch to mainpage
	$('#frontpage').fadeOut(config.animations.pageChangeDuration, function()
	{
		$('#mainpage').fadeIn(config.animations.pageChangeDuration);
		$('#search').focus();
	});

	return false;
};

// Initializes front page
function init()
{
	loadUsername();
	setFormFocus('#login'); // TODO: Move to page change function

	$('#login').submit(loginUser);

	$('#register').submit(function()
	{
		$('#registerDialog').modal('show');
		return false;
	});
	
	var registerSuccess = false;
	
	$('#registerDialog').on('hidden', function()
	{
		if (registerSuccess)
		{
			// Fill in login information
			$('#loginUser').val($('#registerEmail').val());
			$('#loginPass').val('');
			
			// Reset registration form
			$('#register').each(function()
			{
				this.reset();
			});
			
			// Save username
			saveUsername();
			
			// Show confirmation message
			$.jGrowl('You have successfully registered.<br />You can login now.', { sticky: true });
			
			// Show login tab
			navPills.trigger('#frontNav', '#login');
		}
	});

	$('#registerDialog .modal-footer .register').click(function()
	{
		registerSuccess = false;
		
		//alert('Not implemented.');
		
		registerSuccess = true;
		$('#registerDialog').modal('hide');
		
		return false;
	});

	$('#pwForgotDialog').submit(function()
	{
		alert('Not implemented.');

		$('#pwForgotEmail').val('');
		$('#pwForgotDialog').modal('hide');

		return false;
	});

	$('#pwForgotDialog').on('shown', function()
	{
		$('#pwForgotEmail').focus();
	});
};

module.exports = init;