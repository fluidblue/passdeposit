/**
 * PassDeposit
 * Front page initialization
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('jquery.totalStorage');
require('bootstrap');
var setFormFocus = require('../components/set-form-focus');
var config = require('../components/config');

function loadUsername()
{
	$("#loginUser").val($.totalStorage("username"));
}

function saveUsername()
{
	$.totalStorage("username", $("#loginUser").val());
}

function loginUser()
{
	if ($("#loginPass").val().length === 0)
	{
//			$("#loginPass").addClass("invalidInput");
//			return false;
	}

	/*$.post("passdeposit.php",
		{
			userName : this.userName,
			pass: this.passHash
		}
	);*/

	saveUsername();

	// Switch to mainpage
	$("#frontpage").fadeOut(config.animations.pageChangeDuration, function()
	{
		$("#mainpage").fadeIn(config.animations.pageChangeDuration);
		$("#search").focus();
	});

	return false;
};

// Initializes front page
function init()
{
	loadUsername();
	setFormFocus("#login"); // TODO: Move to page change function

	$("#login").submit(loginUser);

	$("#register").submit(function()
	{
		$("#registerDialog").modal('show');
		return false;
	});

	$("#registerDialog .modal-footer .register").click(function()
	{
		alert("Not implemented.");

		$("#registerDialog").modal("hide");

		return false;
	});

	$("#pwForgotDialog").submit(function()
	{
		alert("Not implemented.");

		$("#pwForgotEmail").val("");
		$("#pwForgotDialog").modal("hide");

		return false;
	});

	$("#pwForgotDialog").on('shown', function()
	{
		$("#pwForgotEmail").focus();
	});
};

module.exports = init;