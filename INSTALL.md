# PassDeposit Installation

Please read carefully through both this document and the [readme](README.md#passdeposit).


## Do you need to install PassDeposit yourself?

No, you don't have to. You can use PassDeposit without installation at <http://www.passdeposit.com>. Using the official site will also ensure that you are always using the latest version of PassDeposit, which increases security.

If you decide to host your own installation, you can do so by following the instructions below.


## Installation

Server requirements:

* nodejs
* npm  (node package manager)
* MySQL 5 (or later)

Install using npm:

	sudo npm install -g passdeposit

Start PassDeposit:

	passdeposit --config path/to/config.json

An example configuration is given in the [configuration](#configuration) section in this document.

**Warning**: Your PassDeposit installation will not automatically update itself. Please check regularly for new versions and update your installation if necessary.


## Configuration

Save your configuration to a file, e.g. config.json:

	{
		"port": "8000",

		"https": {
			"certificate": "cert/certificate.pem",
			"privateKey": "cert/privatekey.pem"
		},

		"database": {
			"type": "mysql",
			"host": "localhost",
			"user": "root",
			"password": ""
		}
	}

You need a certificate for PassDeposit. You can generate a self-signed certificate using the following commands:

	openssl genrsa -out privatekey.pem 1024 
	openssl req -new -key privatekey.pem -out certrequest.csr 
	openssl x509 -req -in certrequest.csr -signkey privatekey.pem -out certificate.pem
  

## Development installation

You only need this type of installation if you want to help developing.

* git clone the repository <https://github.com/fluidblue/passdeposit>
* Install npm and gem
* Run 'make install-tools' to install all required development tools
* Run 'make' to build PassDeposit. Alternatively run 'make debug' to build the debug version.
* Start PassDeposit with './build/passdeposit.js'
