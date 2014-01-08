# PassDeposit Installation

Please read carefully through both this document and the [readme](README.md#passdeposit).


## Do you need to install PassDeposit yourself?

No, you don't have to. You can use PassDeposit without installation at <http://www.passdeposit.com>. Using the official site will also ensure that you are always using the latest version of PassDeposit, which increases security.

If you decide to host your own installation, you can do so by following the instructions below.


## Installation

**Server requirements**

* [node.js](http://nodejs.org/)
* [npm](https://npmjs.org/)
* [MongoDB](http://www.mongodb.org/)

**Install using npm** (don't forget the **--global** option)

	sudo npm install --global passdeposit

**Start PassDeposit**

	passdeposit --config path/to/config.json

An example configuration is given in the [configuration](#configuration) section in this document.



**Warning**: Your PassDeposit installation will not automatically update itself.
You can manually update PassDeposit with:

	sudo npm update --global passdeposit

After updating, you need to restart PassDeposit.


## Configuration

Save your configuration to a file, e.g. config.json:

	{
		"port": 8000,

		"https": {
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
  

## Development installation

You only need this type of installation if you want to help developing. You do not need to follow the instructions below, if you installed PassDeposit with npm.

Warning: The development installation should only be used for development and testing. If you want to use PassDeposit, install it with npm instead.

* git clone the repository <https://github.com/fluidblue/passdeposit>
* Install npm and gem
* Run 'make install-tools' to install all required development tools
* Run 'npm install' to install all nodejs dependencies
* Run 'make' to build PassDeposit. Alternatively run 'make debug' to build the debug version.
* Start PassDeposit with 'node build/passdeposit.js'
