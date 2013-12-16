###
# PassDeposit #

Created by Max Geissler
###

# Regular expression for email addresses.
# It is kept very simple. This will hopefully provide support for
# email addresses using new features like new TLD domains etc.
# Matches are like: nowhitespaces@nowhitespaces.nowhitespaces
reEmail = /\S+@\S+\.\S+/

email = (str) ->
	return str? && reEmail.test(str)

password = (str) ->
	return str? && str.length? && str.length > 0

passwordHint = (str) ->
	return str? && str.length? && str.length > 0

module.exports.email = email
module.exports.password = password
module.exports.passwordHint = passwordHint
