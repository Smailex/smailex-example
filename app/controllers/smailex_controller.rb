class SmailexController < ApplicationController
  before_filter :smailex_client_init
  
  def index
    @client
  end

  def create_shipment

    boxes = JSON.parse(params[:boxes],{:symbolize_names => true})

    shipment_params = {
      :signature_type=>params[:signature_type],
      :packages=>boxes,
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
    begin
     shipment = @client.create_shipment(params[:package_type], shipment_params)
    rescue Exception => e
      shipment = {:error=> e}
    end
    respond_to do |format|
      format.js { 	render :partial => 'response',  :locals=>{:response => shipment} }
    end
  end

  def get_rates
    
    # Get shipment rates by shipment_id from smailex
    begin
      rates = @client.get_rates(params[:shipment_id])
    rescue Exception => e
      rates = {:error=> e}
    end

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => rates}  }
    end
    
  end

  def update_shipment

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
    begin
      update_shipment = @client.update_shipment(params[:shipment_id], update_params)
    rescue Exception => e
      update_shipment = {:error=> e}
    end

    respond_to do |format|
     format.js {   render :partial => 'response',  :locals=>{:response => update_shipment}  }
    end
  end

  def validate_addresses
     #validate addresses of shipment with gived ID
    begin
      validate = @client.validate_address(params[:shipment_id])
    rescue Exception => e
      validate = {:error=> e}
    end

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => validate}  }
    end
  end

  def validate_party
    validation = {
      :party=> {
        :name=>params[:party_name],
        :company=> params[:party_company],
        :phone=>params[:party_phone],
        :address=> {
          :zip=> params[:party_zip] ,
          :country=> params[:party_country] ,
          :state=>params[:party_state],
          :city=> params[:"party_city"],
          :line1=> params[:party_line1],
          :line2=>params[:party_line2]
       }
    },
        :service=> {
        :carrier=>params[:carrier]
      }
    }
     #validate addresses of shipment with gived ID
    begin
      validate = @client.validate_party(validation, true)
    rescue Exception => e
      validate = {:error=> e}
    end

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => validate}  }
    end
  end


  def get_cards
    #get list of binded cards, user given in SmailexClient init
    begin
      cards = @client.get_cards()
    rescue Exception => e
      cards = {:error=> e}
    end
    
    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => cards}}
    end
  end

  def get_default_card
    #get default binded card of a user given in SmailexClient init
    begin
      default_card = @client.get_default_card()
    rescue Exception => e
      default_card = {:error=> e}
    end
    
    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => default_card}}
    end
  end

  def create_order
    order_params = {
      :shipments=>[params[:shipment_id]],
      :payment_system=>"WEPAY_PAYMENT_CARD"
    }
    # If we pass payment card id — Smailex will use it and create order with default card, if not — SDK ask for default card first, then pass it's ID in SmailexClient.create_order() method
    if params[:payment_card_id].present? 
      order_params[:payment_card_id] = params[:payment_card_id]
    end

    #create new order
    begin
      order = @client.create_order(order_params)
    rescue Exception => e
      order = {:error=> e}
    end

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => order}}
    end
  end

  def purchase
    #purchase order with given ID
    begin
      purchase_order = @client.purchase(params[:order_id])
    rescue Exception => e
      purchase_order = {:error=> e}
    end

    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => purchase_order}  }
    end
  end

    def get_label
    #get shippming label for order with given ID
    label = @client.get_label(params[:order_id])

    #save it and return link to in for donwload
    #You could you SmailexClient.save_label(order_id, [path_to_save_label]) instead
    # if You don't pass optional agr [path_to_save_label], label will be saved in /tmp/*.pdf
    # otherwise path toy provided will be used
    begin
      File.open("#{Rails.root}/#{params[:order_id]}.pdf","wb"){|file| 
        file.write label
      }
      label_name = params[:order_id]
    rescue Exception => e
      label_name = e
    end

    respond_to do |format|
      format.js  { render :partial => 'label', :locals => {:response => label_name}}
    end
  end

  def save_label
    #Send saved label as attachment
    send_data open("#{Rails.root}/#{params[:label]}.pdf", "rb") { |f| f.read }, :disposition => 'attachment', :filename => "label_for_#{params[:label]}.pdf"
  end


  private
  
  def smailex_client_init
    @client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl, SmailexUsername, SmailexPassword)
  end

end
