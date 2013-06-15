/**
 * PassDeposit
 * Main page initialization
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('bootstrap');
var setFormFocus = require('../components/set-form-focus');
var config = require('../components/config');
var initOptionsDialog = require('./main/options');
var jGrowl = require('../components/jgrowl-extend');

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

function lock()
{
	// TODO: Hide data!
	$('#lockDialog').modal('show');
}

// Initializes main page
function init()
{
	initOptionsDialog();
	
	$('#btnLogout').click(function()
	{
		logout();
	});
	
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
			logout();
		});
		
		// Close dialog
		$('#lockDialog').modal('hide');

		return false;
	});

	// TODO: Multiple typeahead
	var options =
	{
		source: ['Alabama','Alaska','Arizona','Arkansas','California',
			'Colorado','Connecticut','Delaware','Florida','Georgia',
			'Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas',
			'Kentucky','Louisiana','Maine','Maryland','Massachusetts',
			'Michigan','Minnesota','Mississippi','Missouri','Montana',
			'Nebraska','Nevada','New Hampshire','New Jersey','New Mexico',
			'New York','North Dakota','North Carolina','Ohio','Oklahoma',
			'Oregon','Pennsylvania','Rhode Island','South Carolina',
			'South Dakota','Tennessee','Texas','Utah','Vermont',
			'Virginia','Washington','West Virginia','Wisconsin','Wyoming']
	};

	$('#search').typeahead(options);
}

module.exports = init;