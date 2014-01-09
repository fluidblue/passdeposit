###
# PassDeposit #

Created by Max Geissler
###

fs = require "fs"
path = require "path"
optimist = require "optimist"
log = require "./log"
pack = require "../package.json"

config = null

defaultConfig =
	port: 8000

	https: {}

	database:
		type: "mongodb"
		host: "localhost"
		port: 27017
		user: ""
		password: ""
		database: "passdeposit"

	mail: "noreply@example.com"
	domain: "www.example.com"

	verbose: false

get = ->
	return config

getArgv = ->
	argv = optimist
	.usage("PassDeposit server.\nUsage: $0 [options]")
	.options "c",
		alias: "config"
		describe: "Configuration file. Example: path/to/config.json"
	.options "v",
		alias: "version"
		describe: "Show the version"
	.options "h",
		alias: "help"
		describe: "Show this help"
	.argv

	if argv.help
		optimist.showHelp()
		process.exit 0

	if argv.version
		console.log pack.version
		process.exit 0

	if !argv.config
		optimist.showHelp()
		console.log "Missing required arguments: c"
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
		log.error "The config file '" + configFile + "' could not be loaded."
		process.exit 0
	
	# Convert to object
	config = JSON.parse content

	# Merge with default config
	config = mergeRecursive defaultConfig, config

	# Set paths
	config.basePath = path.normalize(path.dirname(configFile))
	config.configFile = configFile

module.exports.load = load
module.exports.get = get
