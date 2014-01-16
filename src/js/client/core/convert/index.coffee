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
	importItems = format.import(data, tag)

	if importItems? && importItems.length?
		count = importItems.length

		if count > 0
			items.addBulk importItems, (response) ->
				callback response, count
		else
			callback
				status: "success"
			, 0
	else
		callback
			status: "import:failed"
		, null

fnExport = (format, callback) ->
	throw new Error("Unsupported format.")

module.exports.import = fnImport
module.exports.export = fnExport
