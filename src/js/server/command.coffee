###
# PassDeposit #

Created by Max Geissler
###

add = (item) ->
	return item

process = (cmd, data) ->
	invalid =
		code: "invalid"

	switch cmd
		when "add" then add(data)
		else invalid

module.exports.process = process
