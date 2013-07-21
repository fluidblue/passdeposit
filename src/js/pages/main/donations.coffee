###
# PassDeposit #
Donation dialog

Created by Max Geissler
###

init = ->
	# Close dialog on click of donation buttons
	$("#donationDialog a.btn").on "click", (e) ->
		$("#donationDialog").modal("hide")
		return true

module.exports = init
