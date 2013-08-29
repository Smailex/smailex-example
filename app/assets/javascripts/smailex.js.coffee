root = exports ? this

hide_all = ->
	$('.loading').show()
	$('#response').hide()

this.make_response = ->
	$('.loading').hide()
	$('#response').show()

this.remove_package = (e) ->
	parent_id = $(this).parent().attr('id')
	$('#'+parent_id).remove()


$(document).ready ->

	$('body').on 'click', 'hand', remove_package

	_id=1
	$('#add_package').click ->
		if $('input[name=packaging]:checked').val() == "box"
			single_package = $('.single_package').html()
			_id = _id+1
			$(this).before("<div class='single_package' id='"+_id+"'>" + single_package+ "<hand class='remove_package' title='Remove this package'></hand></div>") 
		else
			return false

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
			when 'validate_party'
				$('.party').prop 'disabled', false
				$('.party-mandatory').css 'border', 'solid 1px #d9534f'
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
						_packages = new Array()
						boxes =""
						$.each $('.single_package'),  (i) ->
							pack_weight = $(this).find('.weight').val()
							pack_length = $(this).find('.length').val()
							pack_width = $(this).find('.width').val()
							pack_height = $(this).find('.height').val()
							pack_insurance_value = $(this).find('.insurance_value').val()

							_package = new Object()
							_package.insurance_value = pack_insurance_value
							_package.dimensions = new Object()
							_package.dimensions.weight = pack_weight
							_package.dimensions.length = pack_length
							_package.dimensions.width = pack_weight
							_package.dimensions.height = pack_height
							_package.dimensions.units = "imperial"

							_packages.push _package
							boxes = JSON.stringify(_packages)
							console.log boxes
							#return false

						boxes: boxes
						sender_zip: $('#sender_zip').val()
						receiver_zip: $('#receiver_zip').val()
						package_type: package_type
						signature_type: $('#signature_type').val()
					else
						_packages = new Array()
						_package = new Object()
						_package.insurance_value = $('.single_package').find('.insurance_value').val()
						_packages.push _package
						boxes = JSON.stringify(_packages)
						sender_zip: $('#sender_zip').val()
						receiver_zip: $('#receiver_zip').val()
						package_type: package_type
						signature_type: $('#signature_type').val()
						boxes: boxes

					(data, textStatus, jqXHR) ->
						make_response()
						return data

			when 'get_rates'
				$.post '/smailex/get_rates',
					shipment_id: $('#shipment_id').val()

					(data, textStatus, jqXHR) ->
						make_response()
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
						make_response()
						return data
			
			when 'validate_addresses'
				$.post '/smailex/validate_addresses',
					shipment_id: $('#shipment_id').val()

					(data, textStatus, jqXHR) ->
						make_response()
						return data
			when 'validate_party'
				$.post '/smailex/validate_party',
					party_name: $('#receiver_name').val()
					party_email: $('#receiver_email').val()
					party_phone: $('#receiver_phone').val()
					party_company: $('#receiver_company').val()
					party_zip: $('#receiver_zip').val()
					party_country: $('#receiver_country').val()
					party_state: $('#receiver_state').val()
					party_city: $('#receiver_city').val()
					party_line1: $('#receiver_line1').val()
					party_line2: $('#receiver_line2').val()

					carrier: $('#carrier').val()

					(data, textStatus, jqXHR) ->
						make_response()
						return data
			
			when 'create_order'
				$.post '/smailex/create_order',
					shipment_id: $('#shipment_id').val()
					payment_card_id:  $('#payment_card_id').val()

					(data, textStatus, jqXHR) ->
						make_response()
						return data
			
			when 'get_cards'
				$.post '/smailex/get_cards',

					(data, textStatus, jqXHR) ->
						make_response()
						return data

			when 'get_default_card'
				$.post '/smailex/get_default_card',

					(data, textStatus, jqXHR) ->
						make_response()
						return data

			when 'purchase_order'
				$.post '/smailex/purchase',
					order_id: $('#order_id').val()

					(data, textStatus, jqXHR) ->
						make_response()
						return data
			when 'get_label'
				$.post '/smailex/get_label',
					order_id: $('#order_id').val()
				
					(data, textStatus, jqXHR) ->
						make_response()
						return data
			else
				alert "Make a choice!"
		

