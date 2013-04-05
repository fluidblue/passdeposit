/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var tabChangeDuration = 200;

function changeTab(visibleElement)
{
	//$("#content").height($("#loginContent").height());
	//alert($(visibleElement).height());
	
	$(".content").stop(true, true);
	$("#content").stop(true, true);
	
	$("#content").animate({ height: $(visibleElement).height() + 20 }, tabChangeDuration * 2);
	
	$(".content").fadeOut(tabChangeDuration);
	$(visibleElement).delay(tabChangeDuration).fadeIn(tabChangeDuration);
	
	/*$(".content").fadeOut(tabChangeDuration, function()
	{
		
		//$(visibleElement).fadeIn(tabChangeDuration);
		$(visibleElement).delay(1000).css("display", "block");
	});*/
	
	//$(".content").css("display", "none");
	//$(visibleContent).css("display", "block");
};

function App()
{
	this.userName = "";
	this.passHash = "";
	
	this.init = function()
	{
		$(".content").hide();
		changeTab("#loginContent");
		
		$("#loginTab").mouseenter(function()
		{
			changeTab("#loginContent");
			/*var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#loginContent").fadeIn(tabChangeDuration);
			});*/
			//$(".content").css("display", "none");
			//$("#loginContent").css("display", "block");
		});
		
		$("#registerTab").mouseenter(function()
		{
			changeTab("#registerContent");
			/*var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#registerContent").fadeIn(tabChangeDuration);
			});*/
			//$(".content").css("display", "none");
			//$("#registerContent").css("display", "block");
		});
		
		$("#aboutTab").mouseenter(function()
		{
			changeTab("#aboutContent");
			/*var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#aboutContent").fadeIn(tabChangeDuration);
			});*/
			//$(".content").css("display", "none");
			//$("#aboutContent").css("display", "block");
		});
		
		$("#loginForm").submit(this.loginUser);
	};
	
	this.loginUser = function()
	{
		this.passHash = this.getPassHash($("#loginPass").val);
		
		$.post("passdeposit.php",
			{
				userName : this.userName,
				pass: this.passHash
			}
		);
		
		$.cookie("username", this.userName, { expires : 7300 });
	};
	
	this.getPassHash = function(pass)
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