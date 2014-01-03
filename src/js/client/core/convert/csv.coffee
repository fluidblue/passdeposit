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
		else "text"

findTag = (tags, tag) ->
	# Search case insensitive for tag
	tag = tag.toLowerCase()

	for i of tags
		if tags[i].toLowerCase() == tag
			return true

	return false

fnImport = (csv, tag) ->
	rows = $.csv.toArrays(csv)
	header = rows.shift()

	items = []

	for row in rows
		# Create new item
		item =
			fields: []
			tags: [tag]

		for i, column of row
			if column? && column.length > 0
				# Get type from header row
				type = getType(header[i])

				if type == "tags"
					if !findTag(item.tags, column)
						item.tags.push column
				else
					item.fields.push
						type: type
						value: column

		if items.fields.length > 0
			items.push item

	return items

fnExport = (items) ->
	return null

module.exports.import = fnImport
module.exports.export = fnExport
