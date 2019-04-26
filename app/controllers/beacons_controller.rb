class BeaconsController < ApplicationController
    skip_before_action :authorized, only: [:show]

    def create
        beacon = Beacon.new(beacon_params)
        beacon.user_id = token_user_id
        beacon.save
        render json: beacon
    end

    def show 
        beacon = Beacon.find(params[:id])
        # beacon.user["profile"] = Profile.find_by(user_id: beacon.user.id)
        render json: beacon
    end

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
