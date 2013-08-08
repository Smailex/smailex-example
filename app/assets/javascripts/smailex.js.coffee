# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

	$('.radio-btn').click ->
		if $('#envelope').prop('checked')
			$('.box-param').val("")
			$('.box-param').prop 'disabled', true
		else
			$('.box-param').prop 'disabled', false

	$('#create_shipment').click ->
		package_type = $('input[name=packaging]:checked').val()

		$.post '/smailex/create_shipment',

			if package_type == "box"
				sender_zip: $('#sender_zip').val()
				receiver_zip: $('#receiver_zip').val()
				package_type: package_type
				box_weight: $('#weight').val()
				box_length: $('#length').val()
				box_width: $('#width').val()
				box_height: $('#height').val()
			else
				sender_zip: $('#sender_zip').val()
				receiver_zip: $('#receiver_zip').val()
				package_type: package_type

			(data, textStatus, jqXHR) ->
				if data.status == "error"
					alert 'Ajax error'
				else
					return data
