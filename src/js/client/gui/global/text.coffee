###
# PassDeposit #
Language strings

Created by Max Geissler
###

cache = {}

get = (key, replacements...) ->
	value = ""

	# Check cache
	if cache[key]?
		# Use cached value
		value = cache[key]
	else
		# Get language string
		value = $("#text ." + key).html()

		# Trim value
		value = $.trim(value)

		# Save to cache
		cache[key] = value

	# Replace placeholders (%i)
	i = 0
	for replacement in replacements
		i++
		re = new RegExp("%" + i, "g")
		value = value.replace(re, replacement)

	return value

module.exports.get = get
