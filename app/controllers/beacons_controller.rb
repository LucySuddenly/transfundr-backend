class BeaconsController < ApplicationController
    skip_before_action :authorized, only: [:show, :home]

    def create
        beacon = Beacon.new(beacon_params)
        beacon.user_id = token_user_id
        beacon.save
        render json: beacon
    end

    def show 
        beacon = Beacon.find(params[:id])
        render json: beacon
    end

    def home
        beacons = Beacon.all 
        render json: beacons.to_json(:include => { :user => {:include => :profile}})
    end

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
