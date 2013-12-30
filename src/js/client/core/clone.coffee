###
# PassDeposit #
Object cloning

Created by Max Geissler
###

deepCopy = (obj) ->
	# Make a deep copy of the object.
	# Taken from: http://stackoverflow.com/a/728694/2013757

	# Handle the 3 simple types, and null or undefined
	if null == obj || "object" != typeof obj
		return obj
	
	# Handle Date
	if obj instanceof Date
		copy = new Date()
		copy.setTime obj.getTime()
		return copy
	
	# Handle Array
	if obj instanceof Array
		copy = []

		for i of obj
			copy[i] = deepCopy(obj[i])

		return copy
	
	# Handle Object
	if obj instanceof Object
		copy = {}

		for attr of obj
			if obj.hasOwnProperty(attr)
				copy[attr] = deepCopy(obj[attr])

		return copy

	throw new Error("Unable to copy obj! Its type isn't supported.")

module.exports.deepCopy = deepCopy
