###
# PassDeposit #

Created by Max Geissler
###

getDate = ->
	date = new Date()

	day = date.getDate()
	month = date.getMonth() + 1 # Months are zero based
	year = date.getFullYear()

	if day < 10
		day = "0" + day.toString()

	if month < 10
		month = "0" + month.toString()

	hour = date.getHours()
	minute = date.getMinutes()
	second = date.getSeconds()

	if hour < 10
		hour = "0" + hour.toString()

	if minute < 10
		minute = "0" + minute.toString()

	if second < 10
		second = "0" + second.toString()

	return year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second

getLogPrefix = ->
	return "[" + getDate() + " PID: " + process.pid + "] "

error = (message) ->
	console.error getLogPrefix() + "Error: " + message

info = (message) ->
	console.log getLogPrefix() + "Info: " + message

module.exports.error = error
module.exports.info = info
