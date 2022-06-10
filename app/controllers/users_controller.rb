class UsersController < ApplicationController
    before_action :check_user
    skip_before_action :check_user, only: [:create]
    
    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {errors: user.errors}, status: :unprocessable_entity
        end
    end

    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: {errors: "Not authorized"}, status: :unauthorized
        end
    end

    private

    def user_params
        params.permit(:username, :password, :password_digest, :password_confirmation)
    end

    def check_user
        return render json: { error: "User not found"}, status: :unauthorized unless session.include? :user_id
    end
end
