###
# PassDeposit #
Add button

Created by Max Geissler
###

itemlist = require "../../itemlist"
text = require "../../components/text"

init = ->
	$("#mainpage .mainNav .btnAdd .dropdown-menu a").click (e) ->
		href = $(this).attr("href")
		type = href.substr(1)

		item =
			id: 0

			encryption:
				type: "aes256"

			fields: []
			tags: []

		pushField = (type) ->
			item.fields.push
				type: type
				value: ""

		switch type
			when "website"
				item.title = text.get("addWebsite")
				pushField("uri")
				pushField("user")
				pushField("pass")

			when "email"
				item.title = text.get("addEmail")
				pushField("email")
				pushField("pass")

			when "messenger"
				item.title = text.get("addMessenger")
				pushField("service")
				pushField("user")
				pushField("pass")

			when "bookmark"
				item.title = text.get("addBookmark")
				pushField("text")
				pushField("uri")

			else
				item.title = text.get("addOther")
				pushField("service")
				pushField("user")
				pushField("pass")

		itemlist.add item,
			open: true
			position: "top"
			focus: true

		e.preventDefault()
		return

module.exports.init = init
