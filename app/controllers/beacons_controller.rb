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
        total = 0
        beacon.donations.each do |donation|
            if donation.confirmed 
                total += donation.amount
            end
        end
        newbeacon = beacon.to_json(:include => [{:user => {:include => :profile}}, { :donations => {:include => {:user => { :include => :profile}}}}])
        newbeacon = JSON.parse(newbeacon)
        render json: {beacon: newbeacon, total: total}
    end

    def home
        beacons = Beacon.all 
        newbeacons = beacons.map do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            newbeacon = beacon.to_json(:include => { :user => {:include => :profile}})
            newbeacon = JSON.parse(newbeacon)
            hash = {beacon: newbeacon, total: total}
            hash
        end
        render json: newbeacons
    end

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
