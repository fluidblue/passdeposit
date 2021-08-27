# PassDeposit Docker Installation

In this document, an installation using Docker is presented.


## Installation

**Server requirements**

* [Git](https://git-scm.com/)
* [Docker (v20.10.8 or later)](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

**Download using git**

	cd /opt
	git clone https://github.com/fluidblue/passdeposit.git


## Configuration

1. Set a password for the MongoDB `admin` account.
Add your password to the file `install/config/mongodb_initial_admin_password.txt`.

2. Set a password for the MongoDB `passdeposit` account.
Add your password to the file `install/config/mongodb_initial_passdeposit_password.txt`.
Also add the password in the files `install/config/passdeposit.json` and `install/config/mongodb-init-scripts/init.js`.

3. Configure PassDeposit.
Edit the file `install/config/passdeposit.json`. Details on the options are presented in the [configuration](Install.md#configuration) section of the general installation guide.


## Start PassDeposit

	cd /opt/passdeposit
	docker-compose up -d


## Updates

Your PassDeposit installation will only update when restarting the application stack. This happens e.g. during reboot.
It is recommended to update the application manually (e.g. with cron).
The following commands trigger an update:

	cd /opt/passdeposit
	docker-compose down
	docker-compose up -d
