###
# PassDeposit #

Created by Max Geissler
###

log = require "./log"
item = require "./item"

process = (clientID, cmd, data, callback) ->
	log.info clientID + " executes " + cmd

	invalid =
		status: "invalidcommand"

	switch cmd
		when "item.add" then item.add(data, callback)
		when "item.modify" then item.modify(data, callback)
		when "item.remove" then item.remove(data, callback)
		else callback(invalid)

module.exports.process = process
