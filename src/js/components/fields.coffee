###
# PassDeposit #
Fields

Created by Max Geissler
###

ZeroClipboard = require "zeroclipboard"

init = ->
	ZeroClipboard.setDefaults moviePath: "media/zeroclipboard.swf"
	clip = new ZeroClipboard()

	clip.on "load", (client, args) ->
		# TODO: Remove
		alert "movie has loaded"
		return

	$(".itemField .btnCopy").click ->
		input = $(this).parent().children("input:visible")
		
		# TODO: Not working
		clip.setText input.val()
		
		#alert(input.val());
		
		# Show notification
		$.jGrowl $("#text .copiedToClipboard").html()

		return

	$(".itemField .btnOpen").click ->
		input = $(this).parent().children("input:visible")
		uri = input.val()
		
		# Cancel if field is empty
		if uri.length == 0
			# Create notification
			options =
				placement: "bottom"
				title: $("#text .emptyURI").html()
				trigger: "focus"

			input.tooltip options
			
			# Destroy notification when losing focus or typing text
			fnDestroy = ->
				$(this).tooltip "destroy"

			input.one "blur", fnDestroy
			input.one "keydown", fnDestroy
			
			# Show notification
			input.focus()
			return
		
		# Append protocol, if not given
		if uri.indexOf("://") == -1
			uri = "http://" + uri

		window.open uri

		return

	$(".itemField.itemFieldPassword").each (i, elem) ->
		elem = $(elem)

		btnToggle = elem.children(".btnToggleVisiblity")
		txtShow = btnToggle.children(".txtShow")
		txtHide = btnToggle.children(".txtHide")
		inputMasked = elem.children(".inputMasked")
		inputVisible = elem.children(".inputVisible")

		# TODO: Convert to => function
		btnToggle.click ->
			if txtShow.is(":visible")
				txtShow.hide()
				txtHide.show()

				inputVisible.val inputMasked.val()

				inputMasked.hide()
				inputVisible.show()
			else
				txtHide.hide()
				txtShow.show()

				inputMasked.val inputVisible.val()
				
				inputVisible.hide()
				inputMasked.show()

		# Continue with loop
		return true

module.exports.init = init