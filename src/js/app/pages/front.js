/**
 * PassDeposit
 * 
 * @author Max Geissler
 */

define(
[
	"jquery",
	"domReady",
	"jquery.total-storage",
	"bootstrap"
],
function($, domReady)
{
	var tabChangeDuration = 150;

//	function changeTabContent(idContent)
//	{
//		// Cancel if tab is already visible
//		if (!$(".content").is(':animated') && $(idContent).is(":visible"))
//			return;
//
//		// Stop all runnning and queued animations
//		$(".content").stop(true, true);
//
//		// Cleanup
//		$(".content input").blur();
//
//		// Set new focus
//		$(idContent).css("opacity", "0.0").show();
//		setFormFocus(idContent);
//		$(idContent).css("opacity", "1.0").hide();
//
//		// Fade content
//		$(".content").fadeOut(tabChangeDuration);
//		$(idContent).fadeIn(tabChangeDuration);
//	}

	function setFormFocus(parent)
	{
		var lastInput = null;

		$(parent + " input").each(function(i, obj)
		{
			// Save last input which is not of type submit or button.
			if (!$(obj).is(":submit, :button"))
				lastInput = $(obj);

			// Focus first empty input
			if ($(obj).val().length === 0)
			{
				// Focus input
				$(obj).focus();

				// Do not focus again
				lastInput = null;

				// Exit loop
				return false;
			}

			return true;
		});

		if (lastInput)
		{
			// Focus last input
			lastInput.focus();
		}
	}

	function loadUsername()
	{
		$("#loginUser").val($.totalStorage("username"));
	}

	function saveUsername()
	{
		$.totalStorage("username", $("#loginUser").val());
	}

	function setTooltips()
	{
		var options =
		{
			trigger: 'focus',
			placement: 'right'
		};

		$("#registerEmail").tooltip(options);
		$("#registerPass").tooltip(options);
		$("#registerPassHint").tooltip(options);
	}
	
	function loginUser()
	{
		/*$.post("passdeposit.php",
			{
				userName : this.userName,
				pass: this.passHash
			}
		);*/
		
		saveUsername();
		
		// TODO: Change to module system
		$("#frontpage").hide();
		$("#mainpage").show();
		
		return false;
	};
	
	// Initialize page when DOM is ready.
	domReady(function()
	{
		loadUsername();
		setFormFocus("#login");
		setTooltips();

//		$(".content").css("position", "absolute");
		
		$("#frontNav li a").click(function()
		{
			$("#frontNav li").removeClass("active");
			$(this).parent().addClass("active");
			
			/* Snappy */
//			$(".content").addClass("hide");
//			var content = $(this).attr('href');
//			$(content).removeClass("hide");
//			setFormFocus(content);

			/* Fade */
			var content = $(this).attr('href');
			$(".content").fadeOut(tabChangeDuration).promise().done(function()
			{
				$(content).fadeIn(tabChangeDuration);
				setFormFocus(content);
			});

			/* Fade through */
//			var content = $(this).attr('href');
//			$(".content").fadeOut(tabChangeDuration, null);
////			alert($(".content").css("top"));
//			$(content).fadeIn(tabChangeDuration, null);
//			
//			changeTabContent($(this).attr('href'));
			
			return false;
		});
		
		var fnNotImpl = function()
		{
			alert("Not implemented");
			return false;
		};
		
		$("#login").submit(loginUser);
		$("#loginPassForgotten").click(fnNotImpl);
		$("#register").submit(fnNotImpl);
	});
});