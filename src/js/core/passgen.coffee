###
# PassDeposit #
Password generator

Created by Max Geissler
###

generatePassword = ->
	password = ""

	availableSymbols =
	[
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
		"abcdefghijklmnopqrstuvwxyz",
		"0987654321"
	]

	i = 0
	while i < 20
		symbolType = Math.floor(Math.random() * availableSymbols.length)
		symbolChar = Math.floor(Math.random() * availableSymbols[symbolType].length)

		symbol = availableSymbols[symbolType][symbolChar]
		password += symbol

		i++

	return password

module.exports.generatePassword = generatePassword
