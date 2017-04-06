###
# PassDeposit #
Converting

Created by Max Geissler
###

items = require "../items"
csv = require "./csv"

getFormat = (name) ->
	return switch name.toLowerCase()
		when "csv" then csv
		else throw new Error("Unsupported format.")

fnImport = (format, data, tag, callback) ->
	format = getFormat(format)
	result = format.import(data, tag)

	if result? && !result.error? && result.items? && result.items.length?
		if result.items.length > 0
			items.addBulk result.items, (response) ->
				callback response, result.items.length, result.ignored
		else
			callback
				status: "success"
			, 0, result.ignored
	else
		status = if result? && result.error?
			"import:" + result.error
		else
			"import:failed"

		callback
			status: status

fnExport = (format, callback) ->
	format = getFormat(format)

	# Export all items
	itemObjects = items.get()
	result = format.export(itemObjects)

	callback result

module.exports.import = fnImport
module.exports.export = fnExport
