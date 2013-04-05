/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

function App()
{
	this.userName = "";
	this.passHash = "";
	
	this.init = function()
	{
		var tabChangeDuration = 200;
		$("#loginTab").mouseenter(function()
		{
			var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#loginContent").fadeIn(tabChangeDuration);
			});
			//$(".content").css("display", "none");
			//$("#loginContent").css("display", "block");
		});
		
		$("#registerTab").mouseenter(function()
		{
			var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#registerContent").fadeIn(tabChangeDuration);
			});
			//$(".content").css("display", "none");
			//$("#registerContent").css("display", "block");
		});
		
		$("#aboutTab").mouseenter(function()
		{
			var tabs = 3;
			$(".content").fadeOut(tabChangeDuration, function()
			{
				tabs--;
				if (tabs <= 0)
					$("#aboutContent").fadeIn(tabChangeDuration);
			});
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
	
	this.changeTab = function(visibleContent)
	{
		$(".content").css("display", "none");
		$(visibleContent).css("display", "block");
	};
}

$(document).ready(function()
{
	var app = new App();
	app.init();
});