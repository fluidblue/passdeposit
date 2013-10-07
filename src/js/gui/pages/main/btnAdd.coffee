###
# PassDeposit #
Add button

Created by Max Geissler
###

itemlist = require "../../itemlist"

init = ->
	$("#mainpage .mainNav .btnAdd .dropdown-menu a").click (e) ->
		href = $(this).attr("href")
		type = href.substr(1)

		item =
			dateCreated: 0
			dateModified: 0

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
				item.title = $("#text .addWebsite").html()
				pushField("uri")
				pushField("user")
				pushField("pass")

			when "email"
				item.title = $("#text .addEmail").html()
				pushField("email")
				pushField("pass")

			when "messenger"
				item.title = $("#text .addMessenger").html()
				pushField("service")
				pushField("user")
				pushField("pass")

			when "bookmark"
				item.title = $("#text .addBookmark").html()
				pushField("text")
				pushField("uri")

			else
				item.title = $("#text .addOther").html()
				pushField("service")
				pushField("user")
				pushField("pass")

		itemlist.clear()
		itemlist.add(item, true)

		e.preventDefault()
		return

module.exports.init = init
