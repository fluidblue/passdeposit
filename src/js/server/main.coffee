###
# PassDeposit #

Created by Max Geissler
###

cluster = require "cluster"
os = require "os"
config = require "./config"
worker = require "./worker"
log = require "./log"

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
		
		if exitCode == 0
			# Kill all other workers
			for id of cluster.workers
				cluster.workers[id].kill()

			# Exit the master process
			log.info "Shutting down..."
			process.exit 0
		else
			# Log error
			pid = worker.process.pid
			log.error "Worker " + pid + " died (" + exitCode + "). Restarting worker..."

			# Restart worker
			# TODO: Check if worker has run longer than 1 minute
			cluster.fork()

	log.info "PassDeposit is running at https://localhost:" + cfg.port
else
	# Initialize worker
	worker.init(cfg)
