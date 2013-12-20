###
# PassDeposit #
Converting

Created by Max Geissler
###

date = (date) ->
	# Cancel if nothing is given
	if !date?
		return date

	# Make sure we have a Date object and not an ugly string or something worse.
	if !(date instanceof Date)
		date = new Date(date)

	# Return Date object
	return date

module.exports.date = date
