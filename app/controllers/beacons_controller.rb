class BeaconsController < ApplicationController

    def create
        beacon = Beacon.new(beacon_params)
        beacon.user_id = token_user_id
        beacon.save
        render json: beacon
    end

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
