/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

var initFrontPage = require('./pages/front');
var initMainPage = require('./pages/main');
var initPopovers = require('./components/init-popovers');
var navPills = require('./components/nav-pills');
var jGrowl = require('./components/jgrowl-extend');
var fields = require('./components/fields');

// Initialize page when DOM is ready.
$(document).ready(function()
{
	initPopovers();
	navPills.init();
	initFrontPage();
	initMainPage();
	jGrowl.init();
	fields.init();
});