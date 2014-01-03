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
	items.addBulk format.import(data, tag), callback

fnExport = (format, callback) ->
	throw new Error("Unsupported format.")

module.exports.import = fnImport
module.exports.export = fnExport
