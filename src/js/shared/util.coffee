###
# PassDeposit #

Created by Max Geissler
###

isArray = (obj) ->
	return Object::toString.call(obj) == "[object Array]"

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

mergeRecursive = (obj1, obj2) ->
	for p of obj2
		try
			# Property in destination object set; update its value.
			if obj2[p].constructor is Object
				obj1[p] = mergeRecursive(obj1[p], obj2[p])
			else
				obj1[p] = obj2[p]

		catch e
			# Property in destination object not set; create it and set its value.
			obj1[p] = obj2[p]

	return obj1

getRandomInt = (min, max) ->
	return Math.floor(Math.random() * (max - min + 1)) + min

module.exports.isArray = isArray
module.exports.deepCopy = deepCopy
module.exports.mergeRecursive = mergeRecursive
module.exports.getRandomInt = getRandomInt
