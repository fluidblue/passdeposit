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
var jGrowl = require('../components/jgrowl-extend');

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
	jGrowl.closeAll();
	
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
		
		// Empty password field
		$('#loginPass').val('');
	});

	return false;
};

// TODO: Unused?
function showRegisterErrorTip(element, message)
{
	// TODO: Not working, if another popover is already attached to element
	var content = '<div class="errorPopover">' + message + '</div>';
	
	var options =
	{
		trigger: 'manual',
		placement: 'left',
		html: true,
		content: content
	};

	$(element).popover(options);
	$(element).popover('show');
}

function setInputInvalid(jqElem)
{
	jqElem.addClass('invalidInput');
	jqElem.one('keydown', function()
	{
		jqElem.removeClass('invalidInput');
	});
}

function checkNotEmpty(jqElem)
{
	if (jqElem.val().length === 0)
	{
		setInputInvalid(jqElem);
		return false;
	}
	
	return true;
}

function initRegisterTooltips()
{
	var fnContent = function()
	{
		return $('#text .' + $(this).attr('id') + 'Info').html();
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
	$('#registerPassRepeat').popover(options);
	$('#registerPassHint').popover(options);
}

// Initializes front page
function init()
{
	loadUsername();
	setFormFocus('#login'); // TODO: Move to page change function
	initRegisterTooltips();

	$('#login').submit(loginUser);

	$('#register').submit(function()
	{
		if (checkNotEmpty($('#registerEmail')) & checkNotEmpty($('#registerPass')) &
			checkNotEmpty($('#registerPassRepeat')) & checkNotEmpty($('#registerPassHint')))
		{
			$('#registerDialog').modal('show');
		}
		else
		{
			setFormFocus('#login'); // TODO: Not working
		}
		
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
			$.jGrowl($('#text .loginSuccessful').html(), { sticky: true });
			
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

		$('#pwForgotDialog input.email').val('');
		$('#pwForgotDialog').modal('hide');

		return false;
	});

	$('#pwForgotDialog').on('shown', function()
	{
		$('#pwForgotDialog input.email').focus();
	});
};

module.exports = init;