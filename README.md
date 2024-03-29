# PassDeposit

PassDeposit is a simple and secure online password manager.
It allows you to store and access your passwords online.

You may be asking yourself: Can I trust PassDeposit? Yes you can!
PassDeposit has been designed to ensure maximum security for your data.

See the [screenshots](docs/Screenshots.md).


## Installation

You can download and install the latest version of PassDeposit on your server.
See the [installation instructions](docs/Install.md#passdeposit-installation) for more information.


## Features

* Your data is encrypted and decrypted directly in your browser using AES-256
* The server is not able to decrypt your data
* Connections to PassDeposit are secured by SSL/TLS (HTTPS)
* PassDeposit is open source, you can review the source code before trusting it
* Import and export (backup) your data
* You can [host your own installation](docs/Install.md#passdeposit-installation) of PassDeposit to gain maximum control over your data


## Why is it secure?

1. The connection between your browser and the server is secured by SSL/TLS (HTTPS).

2. **The server is not able to decrypt your data**, because your password is never sent to the server.

3. 2-step authentication:

	Your password is hashed in the browser with [PBKDF2](http://en.wikipedia.org/wiki/PBKDF2) (1000 iterations) using SHA-256. The resulting hash acts as your authentication key and is sent to the server.

	The server hashes your authentication key with PBKDF2 (300000 iterations) using SHA-1 and a random salt. The random salt is re-generated every time you change your password.

4. After authentication, the connection is secured by using sessions (256 bit random hashes).


## Tools

* Import your Chrome passwords: [ChromeCSV](https://github.com/cfstras/chromecsv)
* Want to develop a tool or extension? See [API documentation](docs/API.md#passdeposit-api).


## Bugs

Please report bugs to <https://github.com/fluidblue/passdeposit/issues>


## License

Copyright (C) 2013-2021 Max Geissler

This program is free software, licensed under the GNU Affero General Public License (AGPL).
Please see the [License](LICENSE.md) for further information.
