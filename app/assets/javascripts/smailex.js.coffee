root = exports ? this

hide_all = ->
	console.log "HideAll called"
	$('.loading').show()
	$('#response').hide()

this.make_response = ->
	console.log "MakeResponce all called"
	$('.loading').hide()
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
		$('input').css 'border', 'solid 1px #ccc'
		act =  $(this).attr 'id'
		switch act
			when 'create_shipment'
				$('.shipment').prop 'disabled', false
				$('.package_type').prop 'disabled', false
				$('.shipment-mandatory').css 'border', 'solid 1px #d9534f'
			when 'get_rates' 
				$('.rates').prop 'disabled', false
				$('.rates-mandatory').css 'border', 'solid 1px #d9534f'
			when 'update_shipment'
				$('.update').prop 'disabled', false
				#$('.package_type').prop 'disabled', false
				$('.update-mandatory').css 'border', 'solid 1px #d9534f'
				$('.rates-mandatory').css 'border', 'solid 1px #d9534f'
			when 'validate_addresses' 
				$('.rates').prop 'disabled', false
				$('.rates-mandatory').css 'border', 'solid 1px #d9534f'
			when 'create_order'
				$('.rates').prop 'disabled', false
				$('.order').prop 'disabled', false
				$('.rates-mandatory').css 'border', 'solid 1px #d9534f'
			when 'purchase_order'
				$('.purchase').prop 'disabled', false
				$('.purchase-mandatory').css 'border', 'solid 1px #d9534f'
			when 'get_label'
				$('.purchase').prop 'disabled', false
				$('.purchase-mandatory').css 'border', 'solid 1px #d9534f'

		$('.action_chooser').prop 'disabled', false



	$('#send').click ->
		hide_all()
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
						signature_type: $('#signature_type').val()
						insurance_value: $('#insurance_value').val()
					else
						sender_zip: $('#sender_zip').val()
						receiver_zip: $('#receiver_zip').val()
						package_type: package_type
						signature_type: $('#signature_type').val()
						insurance_value: $('#insurance_value').val()

					(data, textStatus, jqXHR) ->
						return data

			when 'get_rates'
				$.post '/smailex/get_rates',
					shipment_id: $('#shipment_id').val()

				(data, textStatus, jqXHR) ->
					return data
			when 'update_shipment'
				$.post '/smailex/update_shipment',
					shipment_id: $('#shipment_id').val()

					sender_name:  $('#sender_name').val()
					sender_email:  $('#sender_email').val()
					sender_phone:  $('#sender_phone').val()
					sender_company:  $('#sender_company').val()

					sender_country: $('#sender_country').val()
					sender_state: $('#sender_state').val()
					sender_city: $('#sender_city').val()
					sender_line1: $('#sender_line1').val()
					sender_line2: $('#sender_line2').val()

					receiver_name: $('#receiver_name').val()
					receiver_email: $('#receiver_email').val()
					receiver_phone: $('#receiver_phone').val()
					receiver_company: $('#receiver_company').val()

					receiver_country: $('#receiver_country').val()
					receiver_state: $('#receiver_state').val()
					receiver_city: $('#receiver_city').val()
					receiver_line1: $('#receiver_line1').val()
					receiver_line2: $('#receiver_line2').val()

					carrier: $('#carrier').val()
					code: $('#code').val()

					insurance_value: $('#insurance_value').val()
				(data, textStatus, jqXHR) ->
					return data
			
			when 'validate_addresses'
				$.post '/smailex/validate_addresses',
					shipment_id: $('#shipment_id').val()

					(data, textStatus, jqXHR) ->
						return data
			when 'create_order'
				$.post '/smailex/create_order',
					shipment_id: $('#shipment_id').val()
					payment_card_id:  $('#payment_card_id').val()

					(data, textStatus, jqXHR) ->
						return data
			when 'get_cards'
				$.post '/smailex/get_cards',

					(data, textStatus, jqXHR) ->
						return data
			when 'get_default_card'
				$.post '/smailex/get_default_card',

					(data, textStatus, jqXHR) ->
						return data

			when 'purchase_order'
				$.post '/smailex/purchase',
					order_id: $('#order_id').val()

					(data, textStatus, jqXHR) ->
						return data
			when 'get_label'
				$.post '/smailex/get_label',
					order_id: $('#order_id').val()
				
					(data, textStatus, jqXHR) ->
						return data
			else
				alert "Make a choice!"
		

