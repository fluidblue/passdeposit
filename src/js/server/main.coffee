###
# PassDeposit #

Created by Max Geissler
###

cluster = require "cluster"
os = require "os"
config = require "./config"
worker = require "./worker"

cfg = config.load()

if cluster.isMaster
	# Create as many instances as CPUs are present
	numCPUs = os.cpus().length
	i = numCPUs

	while i > 0
		# Fork workers
		cluster.fork()
		i--

	cluster.on "exit", (worker, code, signal) ->
		exitCode = worker.process.exitCode
		
		if exitCode != 0
			# Log error
			pid = worker.process.pid
			console.log "Error: worker " + pid + " died (" + exitCode + "). Restarting worker..."

			# Restart worker
			# TODO: Check if worker has run longer than 1 minute
			cluster.fork()

	console.log "PassDeposit is running at https://localhost:" + cfg.port
else
	# Initialize worker
	worker.init(cfg)
