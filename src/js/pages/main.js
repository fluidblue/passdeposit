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

// Initializes main page
function init()
{
	$("#btnLogout").click(function()
	{
		// TODO: Clean up data!

		// Switch to frontpage
		$("#mainpage").fadeOut(config.animations.pageChangeDuration, function()
		{
			$("#frontpage").fadeIn(config.animations.pageChangeDuration);
			setFormFocus("#login");
		});
	});

	// TODO: Multiple typeahead
	var options =
	{
		source: ["Alabama","Alaska","Arizona","Arkansas","California",
			"Colorado","Connecticut","Delaware","Florida","Georgia",
			"Hawaii","Idaho","Illinois","Indiana","Iowa","Kansas",
			"Kentucky","Louisiana","Maine","Maryland","Massachusetts",
			"Michigan","Minnesota","Mississippi","Missouri","Montana",
			"Nebraska","Nevada","New Hampshire","New Jersey","New Mexico",
			"New York","North Dakota","North Carolina","Ohio","Oklahoma",
			"Oregon","Pennsylvania","Rhode Island","South Carolina",
			"South Dakota","Tennessee","Texas","Utah","Vermont",
			"Virginia","Washington","West Virginia","Wisconsin","Wyoming"]
	};

	$("#search").typeahead(options);
}

module.exports = init;