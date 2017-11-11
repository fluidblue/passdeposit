# PassDeposit Installation

Please read carefully through both this document and the [readme](README.md#passdeposit).


## Installation

**Server requirements**

* [node.js (v6 or later)](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [MongoDB](http://www.mongodb.org/)

**Install using npm** (don't forget the **--global** option)

	sudo npm install --global passdeposit

**Start PassDeposit**

	passdeposit --config path/to/config.json

An example configuration is given in the [configuration](#configuration) section.



**Warning**: Your PassDeposit installation will not automatically update itself.
You can manually update PassDeposit with:

	sudo npm update --global passdeposit

After updating, you need to restart PassDeposit.


## Configuration

Save your configuration to a file, e.g. config.json:

	{
		"port": 8000,

		"https": {
			"enabled": true,
			"certFile": "path/to/certificate.pem",
			"keyFile": "path/to/privatekey.pem"
		},

		"database": {
			"type": "mongodb",
			"host": "localhost",
			"port": 27017,
			"user": "",
			"password": "",
			"database": "passdeposit"
		},

		"mail": "noreply@example.com",
		"domain": "www.example.com",

		"verbose": false
	}

The https section is passed to the nodejs TLS module, so you can use all [options](http://nodejs.org/api/tls.html#tls_tls_createserver_options_secureconnectionlistener) from this module.
Additionally, you can use the following options to load certificates from files: pfxFile, keyFile, certFile.

You need a certificate for PassDeposit. You can generate a self-signed certificate using the following commands:

	openssl genrsa -out privatekey.pem 4096
	openssl req -new -key privatekey.pem -out certrequest.csr
	openssl x509 -req -in certrequest.csr -signkey privatekey.pem -out certificate.pem


## System service

You can install passdeposit as a system service. This will allow you to control PassDeposit with:

	service passdeposit start|stop|restart|status

To install PassDeposit as an [Upstart](http://en.wikipedia.org/wiki/Upstart) system service, first perform an [npm installation](#installation).
Then create the file /etc/init/passdeposit.conf:

	# PassDeposit Service
	description "PassDeposit Server"
	author      "Max Geissler"

	# Start after mongodb has started.
	start on started mongodb

	# Stop server. Wait until server has stopped, before continuing system shutdown.
	stop on starting rc RUNLEVEL=[016]

	# Restart the process if it dies with a signal or exit code not given by the 'normal exit' stanza.
	respawn

	# Give up if restart occurs 10 times in 90 seconds.
	respawn limit 10 90

	# Wait 100s between SIGTERM and SIGKILL.
	kill timeout 100

	# Use exec to replace the current process instead of spawning a child process.
	# Use start-stop-daemon to automatically handle PID file.
	exec start-stop-daemon --start --make-pidfile --pidfile /var/run/passdeposit.pid --exec /usr/bin/passdeposit -- --config /etc/passdeposit/config.json >> /var/log/passdeposit.log 2>&1


## Development installation

You only need this type of installation if you want to help developing. You do not need to follow the instructions below, if you installed PassDeposit with npm.

Warning: The development installation should only be used for development and testing.

* git clone the repository <https://github.com/fluidblue/passdeposit>
* Install npm and gem
* Run 'make install-tools' to install all required development tools
* Run 'npm install' to install all nodejs dependencies
* Run 'make' to build PassDeposit. Alternatively run 'make debug' to build the debug version.
* Start PassDeposit with 'node build/passdeposit.js'
