# PassDeposit API

The PassDeposit API is the protocol between the PassDeposit server and the PassDeposit client web application.
You can use it to develop browser plugins, tools or even new clients for PassDeposit.

This document describes the API and how to use it.



## How to use

The API is based on HTTP POST and JSON. The command and its arguments are transmitted as JSON strings in the POST data. The url for the HTTP request is https://address:port/passdeposit.

A request contains the following data:

Field   | Description
--------|-----------------------------------------------
cmd     | Command to be executed
data    | Arguments for the command (not always needed)
userid  | User's ID (not always needed)
session | Current session (not always needed)

Example request:

	{
		"cmd": "user.login",
		"data ": {
			"email": "test@example.com",
			"key": "9R+Yzh3QjimItU80dN+SCNzkWqbM/4Aa9VrxtO5aui4="
		}
	}


The response always contains the field *status*. Depending on the command, there are more fields.

Example response:

	{
		"status": "success",
		"session": "aJIeB8kH0tZdXXIGRt0FSEFGsRMPEJBMivfVe3V+bzI=",
		"userid": "52c4077e774fe2bf30000001"
	}


Please note:

* Responses are gzipped, even if gzip is not specified in Accept-Encoding. This is due to performance reasons.
* All strings must be encoded in UTF-8



## Commands


### user.create

Create a new user on the server.

Field             | Description
------------------|--------------------------------------------------------------------------
cmd               | "user.create"
data.email        | Email address, which also serves as username
data.key          | Password hash. Generated with PBKDF2 (1000 iterations, salted with email). This hash is hashed again on the server with PBKDF2 (300000 iterations, salted with random value).
data.passwordHint | Password hint

The response contains the following fields:

Field        | Description
-------------|-----------------------------------
status       | See [Status codes](#status-codes)



### user.login

Login an existing user.

Field        | Description
-------------|--------------------------------------------------------------------------
cmd          | "user.login"
data.email   | Email address, which also serves as username
data.key     | Password hash. See `user.create`

The response contains the following fields:

Field        | Description
-------------|---------------------------
status       | See [Status codes](#status-codes)
session      | Current session ID
userid       | User's ID



### user.sendPasswordHint

Send the user's password hint to the registered email address.

Field        | Description
-------------|--------------------------------------------------------------------------
cmd          | "user.sendPasswordHint"
data         | Email address

The response contains the following fields:

Field        | Description
-------------|---------------------------
status       | See [Status codes](#status-codes)

Please note: Even if the email address is not found in the database, "success" may be returned.
This prevents enumerating registered email addresses.



### user.reset

Completely reset an existent user account. This will delete all data associated with the user.

Field             | Description
------------------|---------------------------------------------------------------------
cmd               | "user.reset"
data.resetKey     | The reset key is given in the email that is sent to the user when calling `user.sendPasswordHint`. The reset key is only valid for 24 hours.
data.email        | Email address of the user. This must be the email address the user registered with.
data.passwordKey  | Password hash of new password. See `data.key` in `user.create`.
data.passwordHint | New password hint.

The response contains the following fields:

Field        | Description
-------------|---------------------------
status       | See [Status codes](#status-codes)

Please note: Before `user.reset` can be called, `user.sendPasswordHint` must be called to generate a reset key.



### user.update

Update the email address and/or the password for an existent user account.

Field              | Description
-------------------|-----------------------------------------------------------------
cmd                | "user.update"
data.email         | New email address, which also serves as username
data.key           | Password hash of new password. See `data.key` in `user.create`.
data.passwordHint  | New password hint.
data.items         | Array of all user's items or *null* if the user doesn't have items. The items must be encrypted with the new password. Also see [Item data structure](#item-data-structure).
session            | Current session ID (returned from `user.login`)
userid             | User's ID (returned from `user.login`)

You may only specify some of the data parameters. Valid combinations are:

* Change email address only: email, key
* Change password only: key, passwordHint, items
* Change email and password: email, key, passwordHint, items

The response contains the following fields:

Field        | Description
-------------|-----------------------------------------------------------------
status       | See [Status codes](#status-codes)



### item.add

Add a new item.

Field        | Description
-------------|-----------------------------------------------------------------
cmd          | "item.add"
data         | Single item or array of items. See [Item data structure](#item-data-structure).
session      | Current session ID (returned from `user.login`)
userid       | User's ID (returned from `user.login`)

The response contains the following fields:

Field        | Description
-------------|-----------------------------------------------------------------
status       | See [Status codes](#status-codes)
dateCreated  | Creation timestamp. Given as Javascript Date() compatible string.
id           | ID of the new item. If multiple items were added, array of IDs.



### item.modify

Modify an existing item.

Field        | Description
-------------|-----------------------------------------------------------------
cmd          | "item.modify"
data         | Single item or array of items. See [Item data structure](#item-data-structure).
session      | Current session ID (returned from `user.login`)
userid       | User's ID (returned from `user.login`)

The response contains the following fields:

Field        | Description
-------------|-----------------------------------------------------------------
status       | See [Status codes](#status-codes)
dateModified | Modification timestamp. Given as Javascript Date() compatible string. You can update your items' dateModified values with this value.



### item.remove

Remove an existing item.

Field        | Description
-------------|-----------------------------------------------
cmd          | "item.remove"
data.id      | ID of the item to be removed
session      | Current session ID (returned from `user.login`)
userid       | User's ID (returned from `user.login`)

The response contains the following fields:

Field        | Description
-------------|-----------------------------------------------
status       | See [Status codes](#status-codes)



### item.get

Return all items from server.

Field        | Description
-------------|-----------------------------------------------
cmd          | "item.get"
session      | Current session ID (returned from `user.login`)
userid       | User's ID (returned from `user.login`)

The response contains the following fields:

Field        | Description
-------------|-----------------------------------------------
status       | See [Status codes](#status-codes)
items        | Array of items. See [Item data structure](#item-data-structure).



## Status codes

All API functions return a status code:

Status         | Description
---------------|-----------------------------------------------
success        | Everything is OK.
invalidcommand | Unknown command.
input:failed   | Some of the input data is invalid. Example: Invalid email address.
auth:failed    | User authentication failed. Example: Username or password incorrect.
db:failed      | Database error.
db:duplicate   | Duplicate data in database. Example: Already registered email address.
crypt:failed   | Cryptographic function could not be executed (e.g. not enough entropy).
time:failed    | Some of the input data is not valid anymore. Example: Reset key for `user.reset` expired.
mail:failed    | The mail service is not working. The server cannot send mails.



## Item data structure

Items are encrypted. The encryption used for *fields* and *tags* is specified in *encryption*.

Example:

	{
		"id": "52e6d5a2acf0118a05000002",
		"dateCreated": "2014-01-27T21:54:42.563Z",
		"dateModified": "2014-01-27T21:54:42.563Z"
		"tags": [
			{
				"ct": "ME0BeXfW8deX1DHVX0RtCL//1EE8zrS6eDhACLPeabKx",
				"salt": "tHyEoXPq/rQ=",
				"iv": "SugJAR3b1JcwLF7A2synEA=="
			},
			{
				"ct": "ogKljuHtIdtfrDUl32uz/msMaa4=",
				"salt": "y4ghqCjUZ7M=",
				"iv": "voZTB1jU7J2LEP+1ytFAfg=="
			}
		],
		"fields": [
			{
				"type": "user",
				"value": {
					"ct": "o2qAsZVQAHpHm23W1awOmCTKl/5xTAB8",
					"salt": "MJ8QNaAw6OY=",
					"iv": "tNE8acRq2DQ8enBhUzlBdg=="
				}
			},
			{
				"type": "pass",
				"value": {
					"ct": "+RzZe849NMGvXSYmJHlP0l1Dy+qmCQ1r",
					"salt": "8IuQmKgQOr8=",
					"iv": "m468o0DMmDZsg3qMAeRdxg=="
				}
			}
		],
		"encryption": {
			"type": "sjcl",
			"options": {
				"cipher": "aes",
				"adata": "",
				"mode": "ccm",
				"ts": 128,
				"ks": 256,
				"iter": 1000,
				"v": 1
			}
		}
	}
