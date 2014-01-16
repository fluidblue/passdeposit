###
# PassDeposit #
CSV Import/Export

Created by Max Geissler
###

getType = (str) ->
	return switch str.toLowerCase()
		# Tags
		when "tags" then "tags"

		# Fields
		when "email" then "email"
		when "pass" then "pass"
		when "service" then "service"
		when "uri" then "uri"
		when "user" then "user"
		when "text" then "text"

		# Ignore
		when "ignore" then "ignore"

		# Invalid
		else "invalid"

findTag = (tags, tag) ->
	# Search case insensitive for tag
	tag = tag.toLowerCase()

	for i of tags
		if tags[i].toLowerCase() == tag
			return true

	return false

fnImport = (csv, defaultTag) ->
	rows = $.csv.toArrays(csv)
	header = rows.shift()

	if defaultTag?
		defaultTag = $.trim(defaultTag)

	items = []
	ignored = 0

	for row in rows
		# Create new item
		item =
			fields: []
			tags: []

		# Add default tag
		if defaultTag? && defaultTag.length > 0
			item.tags.push defaultTag

		for i, column of row
			if column? && column.length > 0
				# Get type from header row
				type = getType(header[i])

				if type == "tags"
					for tag in column.split(",")
						tag = $.trim(tag)
						if !findTag(item.tags, tag)
							item.tags.push tag
				else if type == "invalid"
					# Import failed
					result =
						error: "data:failed"

					return result
				else if type != "ignore"
					item.fields.push
						type: type
						value: column

		if item.fields.length > 0
			items.push item
		else
			ignored++

	result =
		items: items
		ignored: ignored

	return result

fnExport = (items) ->
	throw new Error("Not implemented.")

module.exports.import = fnImport
module.exports.export = fnExport
