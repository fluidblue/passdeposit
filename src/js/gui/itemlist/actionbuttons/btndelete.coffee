###
# PassDeposit #
itemlist action button: delete

Created by Max Geissler
###

core = require "../../../core"
itemid = require "../itemid"

initTemplate = (template) ->
	btnDelete = template.find(".content .actionButtons .btnDelete")

	# Add popover
	options =
		trigger: "manual"
		placement: "bottom"
		html: true
		content: $("#text .popoverDeleteContent").html()
		title: $("#text .popoverDeleteTitle").html()
		container: template # Avoid jumping buttons (preserve btn-group)

	btnDelete.popover options

	# Add button event
	btnDelete.click (e) ->
		btnDelete.tooltip("hide")
		btnDelete.popover("show")
		return

	# Add popup button events
	$(template).on "click", ".popover .btnCancelDelete", (e) ->
		btnDelete.popover("hide")
		return

	$(template).on "click", ".popover .btnConfirmDelete", (e) ->
		id = itemid.get(template)
		exist = id != 0

		if exist
			# Remove item
			core.item.remove(id)
			template.remove()
		else
			# Cancel creation of new item
			template.find(".content .btnCancel").trigger("click")

		btnDelete.popover("hide")
		return

module.exports.initTemplate = initTemplate
