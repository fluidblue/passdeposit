# PassDeposit Installation

Please read carefully through both this document and the [readme](README.md#passdeposit).


## Do you need to install PassDeposit yourself?

No, you don't have to. You can use PassDeposit without installation at <http://www.passdeposit.com>. Using the official site will also ensure that you are always using the latest version of PassDeposit, which increases security.

If you decide to host your own installation, you can do so by following the instructions below.


## Server requirements

* nginx
* nodejs
* MySQL 5 (or later)


## Installation

* Download the latest version from <https://github.com/fluidblue/passdeposit>
* Install npm and gem
* Run 'make install-tools' to install all required tools
* Run 'make' to compile PassDeposit.
* Copy the build directory (not the src directory!) to your server

Note: In future versions there will be an automatic installer. As of now, only the above method is available.

Warning: Your PassDeposit installation will not automatically update itself, although it is a planned feature. Please check regularly for new versions and update your installation if necessary.
