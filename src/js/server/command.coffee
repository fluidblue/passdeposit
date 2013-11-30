###
# PassDeposit #

Created by Max Geissler
###

log = require "./log"
item = require "./item"
user = require "./user"

process = (clientID, cmd, data, callback) ->
	log.info clientID + " executes " + cmd

	invalid =
		status: "invalidcommand"

	switch cmd
		when "item.add" then item.add(data, callback)
		when "item.modify" then item.modify(data, callback)
		when "item.remove" then item.remove(data, callback)
		when "user.create" then user.create(data.email, data.key, data.passwordHint, callback)
		when "user.login" then user.login(data.email, data.key, callback)
		else callback(invalid)

module.exports.process = process
