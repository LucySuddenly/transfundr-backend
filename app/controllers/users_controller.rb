class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create, :show]

    def create
        user = User.create(user_params)
        if user.valid?
            token = encode_token(user_id: user.id)
            render json: {user: user, jwt: token}, status: :created
        else
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end

    def show 
        user = User.find(params[:id])
        render json: user
    end

    private

    def user_params
        params.permit(:username, :email, :password, :trans, :femme, :nonwhite)
    end
end
