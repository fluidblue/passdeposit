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
	if addr.charAt(addr.length - 1) == "/"
		addr = addr.substring(0, addr.length - 1)

	if addr.indexOf("http://") == 0
		return addr.substring(7)

	if addr.indexOf("https://") == 0
		return addr.substring(8)

	return addr

title = (fields) ->
	user = ""
	email = ""
	service = ""
	uri = ""
	txt = ""

	# Loop through fields in reverse order
	for field in fields by -1
		switch field.type
			when "user" then user = field.value
			when "email" then email = field.value
			when "service" then service = field.value
			when "uri" then uri = webAddress(field.value)
			when "text" then txt = field.value

	# Create title:
	#     (Username | Email) * (ServiceName) * (WebAddress) * (Text)
	# If only WebAddress & Text are present:
	#     Text * WebAddress
	# If title is still empty
	#     Email
	# If title is still empty
	#     "Untitled"

	title = ""
	dot = ' <span class="dot">•</span> '

	addPart = (current, part) ->
		if current.length > 0
			return current + dot + part
		else
			return part

	if user.length <= 0 && email.length <= 0 && service.length <= 0 &&
	uri.length > 0 && txt.length > 0
		title = txt + dot + uri
	else
		if user.length > 0
			title = user

		if title.length <= 0 && email.length > 0
			title = email

		if service.length > 0
			title = addPart(title, service)

		if uri.length > 0
			title = addPart(title, uri)

		if txt.length > 0
			title = addPart(title, txt)

		if title.length <= 0
			title = email

		if title.length <= 0
			title = global.text.get("untitled")

	return title

module.exports.validUri = validUri
module.exports.date = date
module.exports.title = title
