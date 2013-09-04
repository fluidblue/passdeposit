###
# PassDeposit #

Created by Max Geissler
###

fs = require("fs")
path = require("path")
optimist = require("optimist")

defaultConfig =
	port: "8000"

	https:
		certificate: ""
		privateKey: ""

	database:
		type: "mysql"
		host: "localhost"
		user: "root"
		password: ""

getArgv = ->
	argv = optimist
	.usage("PassDeposit server.\nUsage: $0 [options]")
	.options("c",
		demand: true
		alias: "config"
		describe: "Configuration file. Example: path/to/config.json"
	)
	.options("h",
		alias: "help"
		describe: "Show this help"
	)
	.argv

	if argv.help
		optimist.showHelp()
		process.exit 0

	return argv

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

load = ->
	# Get location of config file
	argv = getArgv()
	configFile = argv.config

	# Load config file
	try
		content = fs.readFileSync configFile
	catch e
		console.log "Error: The config file '" + configFile + "' could not be loaded."
		process.exit 1
	
	# Convert to object
	config = JSON.parse content

	# Merge with default config
	config = mergeRecursive defaultConfig, config

	# Resolve path function
	resolvePath = (relative) ->
		return path.resolve(path.dirname(configFile), relative)

	# Load certificate
	try
		config.https.options =
			key: fs.readFileSync(resolvePath(config.https.privateKey))
			cert: fs.readFileSync(resolvePath(config.https.certificate))
	catch e
		console.log "Error: Could not load certificate/privateKey (specified in '" + configFile + "')"
		process.exit 1

	return config

module.exports.load = load
