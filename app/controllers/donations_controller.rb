class DonationsController < ApplicationController
    skip_before_action :authorized, only: [:show]

    def create 
        donation = Donation.create(donation_params)
        render json: donation
    end

    def show
        donation = Donation.find(params[:id])
        render json: donation.to_json(:include => [{ :user => {:include => :profile}}, {:beacon => {:include => {:user => {:include => :profile}}}}])
    end

    private

    def donation_params
        params.permit(:user_id, :beacon_id, :amount, :points, :confirmed)
    end
end
