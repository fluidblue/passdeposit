###
# PassDeposit #
itemlist formats

Created by Max Geissler
###

text = require "../components/text"

validUri = (uri) ->
	# Append http protocol, if not given
	if uri.indexOf("://") == -1
		uri = "http://" + uri

	return uri

date = (date) ->
	# Set current date if none is given
	if !date?
		date = new Date()
	# Make sure we have a Date() and not an ugly string or something worse.
	else if !(date instanceof Date)
		date = new Date(date)

	day = date.getDate()
	month = date.getMonth() + 1 # Months are zero based
	year = date.getFullYear()

	if day < 10
		day = "0" + day.toString()

	if month < 10
		month = "0" + month.toString()

	return year + "-" + month + "-" + day

encryption = (enc) ->
	return switch enc
		when "aes256" then "AES 256"
		else enc

webAddress = (addr) ->
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
			title = text.get("untitled")

	return title

module.exports.validUri = validUri
module.exports.date = date
module.exports.encryption = encryption
module.exports.title = title
