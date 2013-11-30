###
# PassDeposit #

Created by Max Geissler
###

log = require "./log"
item = require "./item"
user = require "./user"

process = (clientID, params, callback) ->
	log.info clientID + " executes " + params.cmd

	authenticate = (callback2) ->
		user.authenticate params.userid, params.session, (authenticated) ->
			if authenticated
				callback2()
			else
				callback
					status: "auth:failed"

	switch params.cmd
		when "user.create"
			user.create(params.data.email, params.data.key, params.data.passwordHint, callback)
		when "user.login"
			user.login(params.data.email, params.data.key, callback)
		when "item.add"
			authenticate ->
				item.add(params.userid, params.data, callback)
		when "item.modify" 
			authenticate ->
				item.modify(params.userid, params.data, callback)
		when "item.remove" 
			authenticate ->
				item.remove(params.userid, params.data, callback)
		when "item.get"
			authenticate ->
				item.get(params.userid, callback)
		else
			callback
				status: "invalidcommand"

module.exports.process = process
