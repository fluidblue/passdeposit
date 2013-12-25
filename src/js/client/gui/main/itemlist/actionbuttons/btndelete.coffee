###
# PassDeposit #
itemlist action button: delete

Created by Max Geissler
###

core = require "../../../../core"
itemid = require "../itemid"
itemlist = require ".."
global = require "../../../global"

initTemplate = (template) ->
	btnDelete = template.find(".content .actionButtons .btnDelete")

	# Add popover
	options =
		trigger: "manual"
		placement: "bottom"
		html: true
		content: global.text.get("popoverDeleteContent")
		title: global.text.get("popoverDeleteTitle")
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
		exist = id != null

		if exist
			# Remove item
			core.items.remove id, (response) ->
				if response.status != "success"
					# Show error
					global.jGrowl.show global.text.get("itemDeleteFailed", response.status)
					return

				itemlist.remove(template)
		else
			# Cancel creation of new item
			template.find(".content .btnCancel").trigger("click")

		btnDelete.popover("hide")
		return

module.exports.initTemplate = initTemplate
