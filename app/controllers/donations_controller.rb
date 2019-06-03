class DonationsController < ApplicationController
    skip_before_action :authorized, only: [:show]

    def create 
        donation = Donation.create(donation_params)
        MailerMailer.donation_email(donation.beacon.user).deliver
        render json: donation
    end

    def show
        donation = Donation.find(params[:id])
        render json: donation.to_json(:include => [{ :user => {:include => :profile}}, {:beacon => {:include => {:user => {:include => :profile}}}}])
    end

    def confirm 
        donation = Donation.find(params["_json"])
        if token_user_id == donation.beacon.user.id
            donation.confirmed = true
            donation.save
        end
        render json: donation.to_json(:include => [{ :user => {:include => :profile}}, {:beacon => {:include => {:user => {:include => :profile}}}}])
    end

    def notifications
        notifications = []
        Donation.all.each do |donation|
            if donation.confirmed == false && donation.beacon.user.id == token_user_id
                notifications << donation
            end
        end
        render json: notifications
    end

    private

    def donation_params
        params.permit(:user_id, :beacon_id, :amount, :points, :confirmed)
    end
end
