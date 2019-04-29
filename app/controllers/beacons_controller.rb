class BeaconsController < ApplicationController
    skip_before_action :authorized, only: [:show, :home, :nearly_there, :needs_help]

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
        #sort by nonwhite and femme
        beacons = Beacon.all.reverse
        first = []
        second = []
        third = []
        beacons.each do |beacon|
            if beacon.user.femme && beacon.user.nonwhite
                first << beacon
            elsif beacon.user.femme || beacon.user.nonwhite 
                second << beacon 
            else
                third << beacon
            end
        end
        beacons = first + second + third
        #add total donated to payload
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

    def nearly_there
        beacons = Beacon.all
        #add total donated to payload
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
        #sort by nearly there
        beacons = newbeacons.sort_by do |beacon| 
            beacon[:total].to_i / beacon[:beacon]["target"].to_i
        end
        #sort by nonwhite and femme
        first = []
        second = []
        third = []
        beacons.each do |beacon|
            if beacon[:beacon]["user"]["femme"] && beacon[:beacon]["user"]["nonwhite"]
                first << beacon
            elsif beacon[:beacon]["user"]["femme"] || beacon[:beacon]["user"]["nonwhite"] 
                second << beacon 
            else
                third << beacon
            end
        end
        beacons = first + second + third
        render json: beacons
    end

    def needs_help
        beacons = Beacon.all
        #add total donated to payload
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
        #sort by nearly there
        beacons = newbeacons.sort_by do |beacon| 
            beacon[:total].to_i / beacon[:beacon]["target"].to_i
        end.reverse
        #sort by nonwhite and femme
        first = []
        second = []
        third = []
        beacons.each do |beacon|
            if beacon[:beacon]["user"]["femme"] && beacon[:beacon]["user"]["nonwhite"]
                first << beacon
            elsif beacon[:beacon]["user"]["femme"] || beacon[:beacon]["user"]["nonwhite"] 
                second << beacon 
            else
                third << beacon
            end
        end
        beacons = first + second + third
        render json: beacons
    end

    private 

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
