class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create, :show]

    def create
        user = User.create(user_params)
        if user.valid?
            token = encode_token(user_id: user.id)
            render json: {user: UserSerializer.new(user), jwt: token}, status: :created
        else
            render json: { error: user.errors.full_messages[0] }, status: :not_acceptable
        end
    end

    def show 
        user = User.find(params[:id])
        beacons = user.beacons.map do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            {beacon: beacon, total: total}
        end
        render json: {user: UserSerializer.new(user), beacons: beacons}
    end

    private

    def user_params
        params.permit(:username, :email, :password, :trans, :femme, :nonwhite)
    end
end
