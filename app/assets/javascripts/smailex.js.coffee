root = exports ? this

this.hide_all = ->
	$('.loading').html("<img src='/assets/loading.gif'/>")
	$('#response').hide()

this.make_response = ->
	$('.loading').html("")
	$('#response').show()

$(document).ready ->

	#package type
	$('.package_type').click ->
		if $('#envelope').prop('checked')
			$('.box-param').val("")
			$('.box-param').prop 'disabled', true
		else
			$('.box-param').prop 'disabled', false
	
	# form fields
	$('.action_chooser').click ->
		$('input').prop 'disabled', true
		act =  $(this).attr 'id'
		switch act
			when 'create_shipment'
				$('.shipment').prop 'disabled', false
				$('.package_type').prop 'disabled', false
			when 'get_rates'
				$('.rates').prop 'disabled', false
			when 'update_shipment'
				$('.update').prop 'disabled', false
				#$('.package_type').prop 'disabled', false
			when 'create_order'
				$('.rates').prop 'disabled', false
			when 'purchase_order'
				$('.rates').prop 'disabled', false

		$('.action_chooser').prop 'disabled', false



	$('#send').click ->
		$('.loading').html("<img src='/assets/loading.gif'/>")
		act = $('input[name=action]:checked', '#request_fields').val()
		switch act
			when 'create_shipment'
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
						#make_response()
						if data.status == "error"
							alert 'Ajax error'
						else
							return data

			when 'get_rates'
				$.post '/smailex/get_rates',
					dataType: 'script'
					shipment_id: $('#shipment_id').val()

				(data, textStatus, jqXHR) ->
					#make_response()
					if data.status == "error"
						alert 'Ajax error'
					else
						return data
			when 'update_shipment'
				$.post '/smailex/update_shipment',
					dataType: 'script'
					shipment_id: $('#shipment_id').val()
					sender_state: $('#sender_state').val()
					sender_city: $('#sender_city').val()
					sender_line1: $('#sender_line1').val()
					sender_line2: $('#sender_line2').val()

					receiver_state: $('#receiver_state').val()
					receiver_city: $('#receiver_city').val()
					receiver_line1: $('#receiver_line1').val()
					receiver_line2: $('#receiver_line2').val()

					carrier: $('#carrier').val()
					code: $('#code').val()
				(data, textStatus, jqXHR) ->
					#make_response()
					if data.status == "error"
						alert 'Ajax error'
					else
						return data
			else
				alert "Make a choice!"
		make_response()
		

