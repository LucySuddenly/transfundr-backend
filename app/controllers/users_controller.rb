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
        #prepare beacons
        beacons = user.beacons.map do |beacon|
            total = 0
            beacon.donations.each do |donation|
                if donation.confirmed 
                    total += donation.amount
                end
            end
            {beacon: beacon, total: total}
        end
        #prepare points
        points = 0
        user.donations.each do |donation|
            if donation.confirmed
                points += donation.points
            end
        end
        new_user = user.to_json(:include => [:profile, {:donations => {:include => {:beacon => {:include => {:user => {:include => :profile}}}}}}])
        new_user = JSON.parse(new_user)
        render json: {user: new_user, beacons: beacons, points: points}
    end

    private

    def user_params
        params.permit(:username, :email, :password, :trans, :femme, :nonwhite)
    end
end
