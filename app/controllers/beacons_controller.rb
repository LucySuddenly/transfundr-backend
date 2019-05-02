require_relative '../../transfundr.rb' 

class BeaconsController < ApplicationController
    skip_before_action :authorized, only: [:show, :home, :nearly_there, :needs_help]

    def create
        beacon = Beacon.new(beacon_params)
        beacon.user_id = token_user_id
        beacon.save
        tweet_beacon("http://www.transfundr.com/beacons/#{beacon.id}", beacon.title)
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
        newbeacons = []
        beacons.each do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            #remove beacons that have met their targets
            if total < beacon.target
                newbeacon = beacon.to_json(:include => { :user => {:include => :profile}})
                newbeacon = JSON.parse(newbeacon)
                hash = {beacon: newbeacon, total: total}
                newbeacons << hash
            end
        end
        render json: newbeacons
    end

    def nearly_there
        beacons = Beacon.all
        #add total donated to payload
        newbeacons = []
        beacons.each do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            #remove beacons that have met their targets
            if total < beacon.target
                newbeacon = beacon.to_json(:include => { :user => {:include => :profile}})
                newbeacon = JSON.parse(newbeacon)
                hash = {beacon: newbeacon, total: total}
                newbeacons << hash
            end
        end
        #sort by nearly there
        beacons = newbeacons.sort_by do |beacon| 
            (beacon[:total].to_i + 1).to_f / (beacon[:beacon]["target"].to_i).to_f
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

    def needs_help
        beacons = Beacon.all
        #add total donated to payload
        newbeacons = []
        beacons.each do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            #remove beacons that have met their targets
            if total < beacon.target
                newbeacon = beacon.to_json(:include => { :user => {:include => :profile}})
                newbeacon = JSON.parse(newbeacon)
                hash = {beacon: newbeacon, total: total}
                newbeacons << hash
            end
        end
        #sort by nearly there
        beacons = newbeacons.sort_by do |beacon| 
            (beacon[:total].to_i + 1).to_f / (beacon[:beacon]["target"].to_i).to_f
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

    private 

    def beacon_params
        params.permit(:title, :text, :target)
    end
end
