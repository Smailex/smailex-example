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
    update_shipment = "123"
    p "PARAMS: #{params}"
    respond_to do |format|
      format.js {   render :partial => 'response',  :locals=>{:response => update_shipment}  }
    end
    
  end

end
