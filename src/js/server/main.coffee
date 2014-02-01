###
# PassDeposit #

Created by Max Geissler
###

cluster = require "cluster"
os = require "os"
config = require "./config"
worker = require "./worker"
log = require "./log"

# Time (ms) to wait before restarting crashed worker
restartWait = 2000

# Server state
terminating = false

terminate = ->
	if terminating
		return

	terminating = true
	log.info "Shutting down..."

	# The master process will exit,
	# after all workers have exited.

init = ->
	# Create as many instances as CPUs are present
	for i of os.cpus()
		# Fork new worker
		cluster.fork()

	cluster.on "exit", (worker, code, signal) ->
		if !terminating
			exitCode = worker.process.exitCode

			if exitCode == 0
				terminate()
			else
				# Log error
				pid = worker.process.pid
				log.error "Worker " + pid + " died (" + exitCode + "). " +
				"Restarting worker in " + Math.round(restartWait / 1000) + " seconds..."

				# Wait short time before restarting worker
				setTimeout ->
					# Restart worker
					cluster.fork()
				, restartWait

	# Set termination handlers
	process.on "SIGINT", terminate
	process.on "SIGTERM", terminate

	log.info "PassDeposit is running at https://localhost:" + config.get().port

main = ->
	config.load()

	if cluster.isMaster
		# Initialize master
		init()
	else
		if config.get().verbose
			log.info "Worker started"

		# Initialize worker
		worker.init()

# Start the server
main()
