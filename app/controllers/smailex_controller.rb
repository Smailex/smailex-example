class SmailexController < ApplicationController
  def index
    @client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
  end

  def create_shipment
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)

    shipment_params = {
      :packages=>[
        {
          :dimensions=>{
            :weight=>params[:box_weight],
            :length=>params[:box_length],
            :width=>params[:box_width],
            :height=>params[:box_height],
            :units=>"imperial"
          }
        }
      ],
        :sender=>{
          :address=>{
           :zip=>params[:sender_zip]
          }
      },
        :receiver=>{
          :address=>{
            :zip=>params[:receiver_zip]
          }
        }
      }

    #Ceate the shipment object and send request to smailex
    shipment = client.create_shipment(params[:package_type], shipment_params)

    respond_to do |format|
    format.js { 	render :partial => 'response',  :locals=>{:response => shipment}	}
    end
  end

  def get_rates
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
    
    # Get shipment rates by shipment_id from smailex
    rates = client.get_rates(params[:shipment_id])

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => rates}  }
    end
    
  end

  def update_shipment
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)

    update_params = {
        :sender=>{
          :name => params[:sender_name],
          :email => params[:sender_email],
          :phone => params[:sender_phone],
          :company => params[:sender_company],
          :address=>{
            :country=> params[:sender_country],
            :state=>params[:sender_state],
            :city=>params[:sender_city],
            :line1=>params[:sender_line1],
            :line2=>params[:sender_line2]

          }
        },
        :receiver=>{
          :name => params[:receiver_name],
          :email => params[:receiver_email],
          :phone => params[:receiver_phone],
          :company => params[:receiver_company],
          :address=>{
            :country=> params[:receiver_country],
            :state=>params[:receiver_state],
            :city=>params[:receiver_city],
            :line1=>params[:receiver_line1],
            :line2=>params[:receiver_line2]

          }
        },
        :service=>{
          :code=>params[:code],
          :carrier=>params[:carrier]
        }
      }

  #update shipment
  update_shipment = client.update_shipment(params[:shipment_id], update_params)

    respond_to do |format|
     format.js {   render :partial => 'response',  :locals=>{:response => update_shipment}  }
    end
  end

  def validate_addresses
     client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
     #validate addresses of shipment with gived ID
     validate = client.validate_address(params[:shipment_id])

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => validate}  }
    end
    
  end


  def get_cards
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
    #get list of binded cards, user given in SmailexClient init
    cards = client.get_cards()
    
    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => cards}}
    end
  end

  def get_default_card
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
    #get default binded card of a user given in SmailexClient init
    default_card = client.get_default_card()
    
    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => default_card}}
    end
  end

  def create_order
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
    order_params = {
      :shipments=>[params[:shipment_id]],
      :payment_system=>"WEPAY_PAYMENT_CARD"
    }
    # If we pass payment card id — Smailex will use it and create order with default card, if not — SDK ask for default card first, then pass it's ID in SmailexClient.create_order() method
    if params[:payment_card_id].present? 
      order_params[:payment_card_id] = params[:payment_card_id]
    end

    #create new order
    order = client.create_order(order_params)

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => order}}
    end
  end

  def purchase
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)

    #purchase order with given ID
    purchase_order = client.purchase(params[:order_id])

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => purchase_order}  }
    end
  end

    def get_label
    client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)

    #purchase order with given ID
    label = client.get_label(params[:order_id])

    # respond_to do |format|
    #   format.js {   render :partial => 'response',  :locals=>{:response => label}  }
    # end
  end


end
