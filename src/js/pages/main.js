/**
 * PassDeposit
 * Main page initialization
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('bootstrap');
require('bootstrap-tagmanager');
var initOptionsDialog = require('./main/options');
var lockDialog = require('./main/lock');
var logout = require('./main/logout');

// Initializes main page
function init()
{
	initOptionsDialog();
	lockDialog.init();
	logout.init();
	
	var optionsTags =
	{
		prefilled: ["work", "home"],
		CapitalizeFirstLetter: false,
		typeahead: true,
		typeaheadSource: ["Pisa", "Rome", "Milan", "Florence", "New York", "Paris", "Berlin", "London", "Madrid"],
		typeaheadDelegate: {},
		delimiters: [9, 13, 44, 32],
		backspace: [8],
		blinkBGColor_1: '#c5eefa',
		blinkBGColor_2: '#f5f5f5',
		hiddenTagListName: 'hiddenTagListA', /* Unique when using multiple tag inputs */
		hiddenTagListId: null,
		tagsContainer: null,
		tagClass: 'tmTagNoInset',
		validator: null,
		onlyTagList: false
	};
	
	$('.tm-input').tagsManager(optionsTags);
	
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