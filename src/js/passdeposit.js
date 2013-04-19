/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var tabChangeDuration = 300;

function changeTabContent(idContent, fnFocus)
{
	// Cancel if tab is already visible
	if (!$(".content").is(':animated') && $(idContent).is(":visible"))
		return;
	
	// Stop all runnning and queued animations
	$(".content").stop(true, true);
	$("#contentContainer").stop(true, true);
	
	// Cleanup
	$(".content input").blur();
	
	// Set new focus
	$(idContent).css("opacity", "0.0").show();
	if (fnFocus)
		fnFocus();
	$(idContent).css("opacity", "1.0").hide();
	
	// Animate container's height
	$("#contentContainer").animate({ height: $(idContent).height() + 20 }, tabChangeDuration);
	
	// Fade content
	$(".content").fadeOut(tabChangeDuration);
	$(idContent).fadeIn(tabChangeDuration);
}

function changeTab(idTab, idContent, fnFocus)
{
	// Change tab header class
	$(".item").removeClass("itemActive");
	$(idTab).addClass("itemActive");
	
	// Change content
	changeTabContent(idContent, fnFocus);
}

function bindTab(idTab, idContent, fnFocus)
{
	var fn = function()
	{
		changeTab(idTab, idContent, fnFocus);
	};
	
	// Bind to DOM events
//	$(idTab).mouseenter(fn); // TODO
	$(idTab).click(fn);
}

function initTabs()
{
	// Focus functions
	var fnLoginFocus = function()
	{
		if ($("#loginUser").val().length == 0)
			$("#loginUser").focus();
		else
			$("#loginPass").focus();
	}
	
	var fnRegisterFocus = function()
	{
		$("#registerEmail").focus();
		
		/*
		var focused = false;
		
		$("#registerContent input").each(function(i, obj)
		{
			// Focus first empty input
			if ($(obj).val().length == 0)
			{
				focused = true;
				$(obj).focus();
				
				// Exit loop
				return false;
			}
			
			return true;
		});
		
		if (!focused)
		{
			// Focus submit button
			$("#registerContent :submit").focus();
		}
		*/
	}
	
	// Startpage
	$(".content").hide();
	changeTab("#loginTab", "#loginContent", fnLoginFocus);
	
	// Bind events
	bindTab("#loginTab", "#loginContent", fnLoginFocus);
	bindTab("#registerTab", "#registerContent", fnRegisterFocus);
	bindTab("#aboutTab", "#aboutContent", null);
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
	var options =
	{
		defaultPosition: "right",
		maxWidth: "250px",
		activation: "focus",
		delay: 0
	};
	
	$("#registerEmail").tipTip(options);
	$("#registerPassHint").tipTip(options);
	$("#registerPass").tipTip(options);
	
	// Resize fix for tipTip
	$(window).resize(function()
	{
		$("#tiptip_holder").hide();
	});
	
	$(window).afterResize(function()
	{
		$(document.activeElement).triggerHandler("focus");
	}, false, 100 );
}

function App()
{
	var userName = "";
	var passHash = "";
	
	this.init = function()
	{
		loadUsername();
		initTabs();
		setTooltips();
		
		$("#loginPassForgotten").click(function() { alert("Not implemented"); return false; } );
		
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