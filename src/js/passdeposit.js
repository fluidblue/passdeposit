/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

// Third party dependencies are in the lib folder
// Configure loading modules from the lib directory, except 'app' ones
requirejs.config(
{
	"baseUrl": "js/lib",
	"paths":
	{
		"app": "../app"
	},
	"shim":
	{
		"jquery.afterresize": ["jquery"],
		"jquery.tipTip": ["jquery"],
		"jquery.total-storage": ["jquery"]
	}
});

// Load the front page to start the app
requirejs(["app/pages/front"]);
