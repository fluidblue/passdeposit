/**
 * PassDeposit
 * Build configuration for r.js
 * 
 * @author Max Geissler
 */

// Third party dependencies are in the lib folder
// Configure loading modules from the lib directory, except 'app' ones
({
	baseUrl: "lib",
	paths:
	{
		"app": "../app"
	},
	shim:
	{
		"bootstrap" : ['jquery'],
		"jquery.total-storage": ["jquery"],
		"jquery-ui": ["jquery"]
	},
	include: "app/license",
	mainConfigFile: "passdeposit-config.js",
	name: "app/pages/front"
})
