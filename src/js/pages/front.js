/**
 * PassDeposit
 * Front page initialization
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('jquery.totalStorage');
require('bootstrap');
var initNavPills = require('../components/init-nav-pills');
var setFormFocus = require('../components/set-form-focus');
var setTooltips = require('../components/set-tooltips');
var pageChangeFadeDuration = require('../components/page-change');

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
	$("#frontpage").fadeOut(pageChangeFadeDuration, function()
	{
		$("#mainpage").fadeIn(pageChangeFadeDuration);
		$("#search").focus();
	});

	return false;
};

// Initializes front page
module.exports = function()
{
	loadUsername();
	setFormFocus("#login");
	setTooltips();
	initNavPills();

	$("#login").submit(loginUser);

	$("#register").submit(function()
	{
		$("#registerDialog").modal('show');
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