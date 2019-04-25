class ProfilesController < ApplicationController
    skip_before_action :authorized, only: [:show]

    def create
        profile = Profile.new(profile_params)
        profile.user_id = token_user_id
        profile.save
        render json: profile
    end
    
    private

    def profile_params
        params.permit(:bio, :cover_img, :profile_img, :venmo, :cash, :paypal, :zelle)
    end
end
