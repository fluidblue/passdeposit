###
# PassDeposit #
Language strings

Created by Max Geissler
###

get = (key, replacements...) ->
	# Get language string
	value = $("#text ." + key).html()

	# Trim value
	value = $.trim(value)

	# Replace placeholders (%i)
	i = 0
	for replacement in replacements
		i++
		re = new RegExp("%" + i, "g")
		value = value.replace(re, replacement)

	return value

module.exports.get = get
