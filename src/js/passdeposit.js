/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

function setUserNameCookie(name)
{
	$.cookie("username", name, { expires : 7300 });
}