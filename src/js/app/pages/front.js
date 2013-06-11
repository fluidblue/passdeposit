/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var $ = require('jquery');
require('jquery.totalStorage');
require('bootstrap');

var navPillFadeDuration = 200;
var pageChangeFadeDuration = 200;

function setFormFocus(parent)
{
	var lastInput = null;

	$(parent + " input").each(function(i, obj)
	{
		// Save last input which is not of type submit or button.
		if (!$(obj).is(":submit, :button"))
			lastInput = $(obj);

		// Focus first empty input
		if ($(obj).val().length === 0)
		{
			// Focus input
			$(obj).focus();

			// Do not focus again
			lastInput = null;

			// Exit loop
			return false;
		}

		return true;
	});

	if (lastInput)
	{
		// Focus last input
		lastInput.focus();
	}
}

function loadUsername()
{
	$("#loginUser").val($.totalStorage("username"));
}

function saveUsername()
{
	$.totalStorage("username", $("#loginUser").val());
}

function setTooltips()
{
	var fnContent = function()
	{
		return $(".tooltip[data-owner=" + $(this).attr('id') + "]").html();
	};

	var options =
	{
		trigger: 'focus',
		placement: 'right',
		html: true,
		content: fnContent
	};

	$("#registerEmail").popover(options);
	$("#registerPass").popover(options);
	$("#registerPassHint").popover(options);

	// Nasty fix for repositioning popover on resize
	$(window).resize(function()
	{
		if ($(".popover").is(":visible"))
		{
			var popover = $(".popover");
			popover.addClass("noTransition");
			$("input:focus").popover('show');
			popover.removeClass("noTransition");
		}
	});
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

function initNavPills()
{
	// Speed up content change by bypassing CSS blur transition
	// by using mousedown instead of click event.
	$(".nav-pills li a").mousedown(function()
	{
		var parent = $(this).parent();

		// Cancel if already active
		if (parent.hasClass("active"))
			return;

		// Get target (group)
		var target = $(this).parent().parent().attr("data-target");

		// Set nav-pill
		$(".nav-pills[data-target=" + target + "] li").removeClass("active");
		parent.addClass("active");

		// Stop all runnning and queued animations
		var allContent = $("." + target + " .navContent");
		allContent.stop(true, true);

		// Fade old content out, fade new content in and set focus
		var content = $(this).attr('href');
		// TODO: Check removal of promise/done
		allContent.fadeOut(navPillFadeDuration).promise().done(function()
		{
			$(content).fadeIn(navPillFadeDuration);
			setFormFocus(content);
		});
	});

	$(".nav-pills li a").click(function()
	{
		// Suppress link opening
		return false;
	});
}

// Initialize page when DOM is ready.
$(document).ready(function()
{
	loadUsername();
	setFormFocus("#login");
	setTooltips();
	initNavPills();

	var fnNotImpl = function()
	{
		alert("Not implemented");
		return false;
	};

	$("#login").submit(loginUser);

	$("#register").submit(function()
	{
		$("#registerDialog").modal('show');
		return false;
	});

	$("#pwForgot").submit(function()
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

	$("#btnLogout").click(function()
	{
		// TODO: Clean up data!

		// Switch to frontpage
		$("#mainpage").fadeOut(pageChangeFadeDuration, function()
		{
			$("#frontpage").fadeIn(pageChangeFadeDuration);
			setFormFocus("#login");
		});
	});

	// TODO: Move to main.js
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
});