###
# PassDeposit #

Created by Max Geissler
###

add = (item) ->
	ret =
		status: "success"
		id: 100

	return ret

process = (cmd, data) ->
	invalid =
		status: "invalidcommand"

	switch cmd
		when "add" then add(data)
		else invalid

module.exports.process = process
