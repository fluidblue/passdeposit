/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

function App()
{
	var userName = "";
	var passHash = "";
	
	this.init = function()
	{
		loadUsername();
		initTabs();
		setTooltips();
		
		var fnNotImpl = function()
		{
			alert("Not implemented");
			return false;
		};
		
		$("#loginForm").submit(loginUser);
		$("#loginPassForgotten").click(fnNotImpl);
		$("#registerForm").submit(fnNotImpl);
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
		
		$("#frontpage").hide();
		$("#mainpage").show();
		
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