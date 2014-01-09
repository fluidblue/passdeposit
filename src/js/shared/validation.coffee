###
# PassDeposit #

Created by Max Geissler
###

# Regular expression for email addresses.
# It is kept very simple. This will hopefully provide support for
# email addresses using new features like new TLD domains etc.
# Matches are like: nowhitespaces@nowhitespaces.nowhitespaces
reEmail = /^\S+@\S+\.\S+$/

# Regular expression for safe passwords.
#
# A safe password must fulfill:
#   * at least one uppercase letter
#   * at least one lowercase letter
#   * 8 characters or longer
#
# This is a modified version of
# http://imar.spaanjaars.com/297/regular-expression-for-a-strong-password
rePassword = /(?=^.{8,}$)(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/

email = (str) ->
	return str? && reEmail.test(str)

password = (str) ->
	return str? && rePassword.test(str)

passwordHint = (str) ->
	return str? && str.length? && str.length > 0

module.exports.email = email
module.exports.password = password
module.exports.passwordHint = passwordHint
