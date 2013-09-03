###
# PassDeposit #

Created by Max Geissler
###

cluster = require("cluster")
numCPUs = require("os").cpus().length

worker = require("./worker")

port = 8000

if cluster.isMaster
	# Create as many instances as CPUs are present
	i = numCPUs

	while i > 0
		# Fork workers
		cluster.fork()
		i--

	cluster.on "exit", (worker, code, signal) ->
		console.log "worker " + worker.process.pid + " died"
		# TODO: Restart worker?

	console.log "PassDeposit is running at https://localhost:" + port
else
	# Initialize worker
	worker.init(port)
