/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var initFrontPage = require('./pages/front');
var initMainPage = require('./pages/main');
var initNavPills = require('./components/init-nav-pills');
var initTooltips = require('./components/init-tooltips');

// Initialize page when DOM is ready.
$(document).ready(function()
{
	initTooltips();
	initNavPills();
	initFrontPage();
	initMainPage();
});