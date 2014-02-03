###
# PassDeposit #
itemlist formats

Created by Max Geissler
###

global = require "../../global"
core = require "../../../core"

validUri = (uri) ->
	# Append http protocol, if not given
	if uri.indexOf("://") == -1
		uri = "http://" + uri

	return uri

date = (date) ->
	# Set current date if none is given
	if !date?
		date = new Date()

	day = date.getDate()
	month = date.getMonth() + 1 # Months are zero based
	year = date.getFullYear()

	if day < 10
		day = "0" + day.toString()

	if month < 10
		month = "0" + month.toString()

	return year + "-" + month + "-" + day

webAddress = (addr) ->
	if addr.indexOf("http://") == 0
		addr = addr.substring(7)

	if addr.indexOf("https://") == 0
		addr = addr.substring(8)

	if addr.charAt(addr.length - 1) == "/"
		addr = addr.substring(0, addr.length - 1)

	if addr.indexOf("www.") == 0 && addr.length > 4
		addr = addr.substring(4)

	return addr

title = (fields) ->
	user = null
	email = null
	service = null
	uri = null
	txt = null

	# Loop through fields in reverse order
	for field in fields by -1
		switch field.type
			when "user" then user = field.value
			when "email" then email = field.value
			when "service" then service = field.value
			when "uri" then uri = webAddress(field.value)
			when "text" then txt = field.value

	# Create title:
	#
	# If only uri and text is present:
	#     "text * uri"
	# else
	#     "service * uri * (user | email)"
	#
	# If title is still empty
	#     "Untitled"

	title = ""
	dot = ' <span class="dot">•</span> '

	addPart = (current, part) ->
		if current.length > 0
			return current + dot + part
		else
			return part

	valid = (str) ->
		return str? && str.length > 0

	if !valid(user) && !valid(email) && !valid(service) && valid(uri) && valid(txt)
		title = txt + dot + uri
	else
		if valid(service)
			title = service

		if valid(uri)
			title = addPart(title, uri)

		if valid(user)
			title = addPart(title, user)
		else if valid (email)
			title = addPart(title, email)

		if title.length <= 0
			title = global.text.get("untitled")

	return title

module.exports.validUri = validUri
module.exports.date = date
module.exports.title = title
