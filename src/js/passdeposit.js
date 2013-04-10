/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var tabChangeDuration = 400;

function changeTabContent(idContent)
{
	// Stop all runnning and queued animations
	$(".content").stop(true, true);
	$("#contentContainer").stop(true, true);
	
	// Animate container's height
	$("#contentContainer").animate({ height: $(idContent).height() + 10 }, tabChangeDuration);
	
	// Fade content
	$(".content").fadeOut(tabChangeDuration);
	$(idContent).fadeIn(tabChangeDuration);
}

function changeTab(idTab, idContent)
{
	// Stop all runnning and queued animations
	$(".tab").stop(true, true);
	
	// Change tab header class
	$(".tab").removeClass("tabActive", tabChangeDuration);
	$(idTab).addClass("tabActive", tabChangeDuration);
	
	// Change content
	changeTabContent(idContent);
}

function bindTab(idTab, idContent)
{
	var fn = function()
	{
		changeTab(idTab, idContent);
	};
	
	// Bind to mouseenter and click event.
	$(idTab).mouseenter(fn).click(fn);
}

function initTabs()
{
	$(".content").hide();
	changeTab("#loginTab", "#loginContent");
	
	bindTab("#loginTab", "#loginContent");
	bindTab("#registerTab", "#registerContent");
	bindTab("#aboutTab", "#aboutContent");
}

function loadUsername()
{
	$("#loginUser").val($.totalStorage("username"));
}

function saveUsername()
{
	$.totalStorage("username", $("#loginUser").val());
}

function App()
{
	var userName = "";
	var passHash = "";
	
	this.init = function()
	{
		loadUsername();
		initTabs();
		
		$(".text").tipTip({defaultPosition: "right", maxWidth: "250px", activation: "focus"});
		
		$("#loginForm").submit(loginUser);
	};
	
	var loginUser = function()
	{
		passHash = getPassHash($("#loginPass").val);
		
		/*$.post("passdeposit.php",
			{
				userName : this.userName,
				pass: this.passHash
			}
		);*/
		
		saveUsername();
		
		return false;
	};
	
	var getPassHash = function(pass)
	{
		// TODO
		return pass;
	};
}

$(document).ready(function()
{
	var app = new App();
	app.init();
});