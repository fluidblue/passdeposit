###
# PassDeposit #

Created by Max Geissler
###

add = (item) ->
	# TODO
	item.id = 100
	item.dateCreated = 0
	item.dateModified = 0
	item.encryption =
		type: "aes256"
		param0: 0
		param1: 1

	ret =
		status: "success"
		item: item

	return ret

modify = (item) ->
	# TODO
	item.dateCreated = 0
	item.dateModified = 0
	item.encryption =
		type: "aes256"
		param0: 0
		param1: 1

	ret =
		status: "success"
		item: item

	return ret

remove = (id) ->
	# TODO

	ret =
		status: "success"

	return ret

process = (cmd, data) ->
	invalid =
		status: "invalidcommand"

	switch cmd
		when "add" then add(data)
		when "modify" then modify(data)
		when "remove" then remove(data)
		else invalid

module.exports.process = process
