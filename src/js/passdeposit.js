/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var initFrontPage = require('./pages/front');
var initMainPage = require('./pages/main');
var initTooltips = require('./components/init-tooltips');
var navPills = require('./components/nav-pills');
var jGrowl = require('./components/jgrowl-extend');

// Initialize page when DOM is ready.
$(document).ready(function()
{
	initTooltips();
	navPills.init();
	initFrontPage();
	initMainPage();
	jGrowl.init();
});