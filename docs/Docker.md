# PassDeposit Docker Installation

For installing PassDeposit using Docker, follow the steps in this guide.


## Installation

**Server requirements**

* Linux (e.g. Debian, Ubuntu, Manjaro, ...)
* [Git](https://git-scm.com/)
* [Docker (v20.10.8 or later)](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)

**Download using git**

	cd /opt
	git clone https://github.com/fluidblue/passdeposit.git


## Configuration

1. Set a password for the MongoDB `admin` account:
Create the file `install/config/mongodb_initial_admin_password.txt` and save a new password for the `admin` account in it.

2. Set a password for the MongoDB `passdeposit` account:
Create the file `install/config/mongodb_initial_passdeposit_password.txt` and save a new password for the `passdeposit` account in it.

3. Copy the file `install/config/mongodb-init-scripts/init.js.sample` to `install/config/mongodb-init-scripts/init.js`.
Edit the file and set the MongoDB `passdeposit` account password (from step 2).

4. Configure PassDeposit.
Copy the file `install/config/passdeposit-sample.json` to `install/config/passdeposit.json`.
Then, edit the file to configure your PassDeposit installation.
Be sure to set your password for the MongoDB `passdeposit` account (from step 2).
Details on other options are presented in the [configuration](Install.md#configuration) section of the general installation guide.


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


## Automatic start on boot

You can automatically start PassDeposit when the system boots.
Create the file `/etc/systemd/system/passdeposit.service` and add the following content:

	[Unit]
	Description=PassDeposit
	Requires=docker.service
	After=docker.service

	[Service]
	Type=oneshot
	RemainAfterExit=yes

	User=root
	Group=docker
	WorkingDirectory=/opt/passdeposit

	# Create application stack before starting (if not already created)
	ExecStartPre=/usr/bin/docker-compose -f docker-compose.yml up --no-recreate --no-start

	# Start application stack
	ExecStart=/usr/bin/docker-compose -f docker-compose.yml start

	# Stop application stack
	ExecStop=/usr/bin/docker-compose -f docker-compose.yml stop

	[Install]
	WantedBy=multi-user.target

You can now control PassDeposit with:

	sudo systemctl start|stop|status passdeposit

To start PassDeposit at boot, execute the following command:

	sudo systemctl enable passdeposit
