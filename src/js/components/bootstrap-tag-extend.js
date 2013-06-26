/**
 * PassDeposit
 * Main page initialization
 * 
 * @author Max Geissler
 */

//TODO: UNUSED!

var $ = require('bootstrap');
require('bootstrap-tag');

function setWidth(element)
{
	// Container has class .tags
	var container = $(element);
	var input = container.children("input[type=text]");
	var lastTag = container.children('.tag:last');

	var fullWidth = container.width();
	var newWidth = fullWidth;

	if (lastTag.length)
	{
		var lastTagLeft = lastTag.position().left;
		var lastTagWidth = lastTag.outerWidth();

		newWidth -= (lastTagLeft + lastTagWidth);

		// Check min-width
		var minWidth = parseInt(input.css("min-width"));

		if (minWidth > 0 && newWidth < minWidth)
			newWidth = fullWidth;
	}

	input.width(newWidth);
}

function setAllWidth()
{
	$(".tags").each(function(index, element)
	{
		setWidth(element);
	});
}

$(window).resize(setAllWidth);
setAllWidth();

module.exports.setWidth = setWidth;