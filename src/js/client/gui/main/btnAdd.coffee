###
# PassDeposit #
Add button

Created by Max Geissler
###

itemlist = require "./itemlist"
global = require "../global"

init = ->
	$("#mainpage .mainNav .btnAdd .dropdown-menu a").click (e) ->
		e.preventDefault()
		
		href = $(this).attr("href")
		type = href.substr(1)

		item =
			id: 0
			fields: []
			tags: []

		pushField = (type) ->
			item.fields.push
				type: type
				value: ""

		switch type
			when "website"
				item.title = global.text.get("addWebsite")
				pushField("uri")
				pushField("user")
				pushField("pass")

			when "email"
				item.title = global.text.get("addEmail")
				pushField("email")
				pushField("pass")

			when "messenger"
				item.title = global.text.get("addMessenger")
				pushField("service")
				pushField("user")
				pushField("pass")

			when "bookmark"
				item.title = global.text.get("addBookmark")
				pushField("text")
				pushField("uri")

			else
				item.title = global.text.get("addOther")
				pushField("service")
				pushField("user")
				pushField("pass")

		itemlist.add item,
			open: true
			position: "top"
			focus: true

		return

module.exports.init = init
