/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var initFrontPage = require('./pages/front');
var initMainPage = require('./pages/main');

// Initialize page when DOM is ready.
$(document).ready(function()
{
	initFrontPage();
	initMainPage();
});