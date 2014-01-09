###
# PassDeposit #

Created by Max Geissler
###

email = require "email"
fs  = require "fs"
path = require "path"
config = require "./config"
log = require "./log"

Email = email.Email
templates = []

send = (to, subject, text, callback) ->
	try
		mail = new Email
			from: "PassDeposit <" + config.get().mail + ">"
			to: to
			subject: subject
			body: text

		mail.send()

		callback(null)
	catch e
		log.error "Could not send mail to " + to + " (" + log.errmsg(e) + ")"
		callback(e)

	return

template = (name, replacements = null) ->
	# Check if template is cached
	if !templates[name]?
		file = path.resolve(__dirname, "./msg/" + name + ".msg")

		# Read file
		lines = fs.readFileSync(file).toString().split("\n")

		# The subject is the first line
		subject = lines.shift()

		# The message consists of all other lines
		text = lines.join("\n")

		# Cache the template
		templates[name] =
			subject: subject
			text: text

	# Get a template clone from cache.
	# We need a clone to be able to modify the contents
	# without altering the cached template.
	tpl =
		subject: templates[name].subject
		text: templates[name].text

	# Replace placeholders
	if replacements?
		for key, value of replacements
			re = new RegExp(key, "g")
			tpl.text = tpl.text.replace(re, value)

	# Return template
	return tpl

module.exports.send = send
module.exports.template = template
