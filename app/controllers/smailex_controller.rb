class SmailexController < ApplicationController
  def index
  	@client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
  end

  def create_shipment
  	client = SmailexClient.new(SmailexClientID, SmailexClientSecret, SmailexStageAPIUrl)
  	
  	p "type: #{params[:package_type]}"

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

  	#Ceate the shipment object
  	shipment = client.create_shipment(params[:package_type], shipment_params)

  	respond_to do |format|
		format.js { 	render :partial => 'shipment',  :locals=>{:shipment => shipment}	}
	end
  end

end
