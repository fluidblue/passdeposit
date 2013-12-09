###
# PassDeposit #

Created by Max Geissler
###

email = (str) ->
	return str? && str.length? && str.length > 0

password = (str) ->
	return str? && str.length? && str.length > 0

passwordHint = (str) ->
	return str? && str.length? && str.length > 0

module.exports.email = email
module.exports.password = password
module.exports.passwordHint = passwordHint
