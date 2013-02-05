# PassDeposit Installation

Please read carefully through both this document and Readme.md


## Do you need to install PassDeposit yourself?

No, you don't have to. You can use PassDeposit without installation at <http://www.passdeposit.com>. Using the official site will also ensure that you are always using the latest version of PassDeposit, which increases security.

If you decide to host your own installation, you can do so by following the instructions below.


## Requirements

* SSL enabled webserver (e.g. Apache2, lighttpd, ...)
* PHP 5.4 (or higher)
* MySQL 5 (or higher)

Note: For testing PassDeposit locally, you can use XAMPP: <http://www.apachefriends.org/en/xampp.html>. It is however not recommended to use XAMPP for anything else then testing.


## Installation

* Download the latest version from <https://github.com/fluidblue/passdeposit>
* Copy everything in the src directory to your server
* Import src/install/passdeposit.sql to your MySQL database (e.g. with phpMyAdmin)
* Copy src/include/config.sample.php to src/include/config.php
* Edit src/include/config.php to match your server configuration

Note: In future versions there will be an automatic installer. As of now, only the above method is available.

Warning: Your PassDeposit installation will not automatically update itself, although it is a planned feature. Please check regularly for new versions and update your installation if necessary.