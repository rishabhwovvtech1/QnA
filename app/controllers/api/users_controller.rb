class Api::UsersController < ApplicationController
    def index
        users = User.all
        render json: {status: 200, message: "success", data: users}
    end
    def show
        user = User.find(params[:id])
        render json: {data: user}, each_serializer: UserSerializer
    end

    def create
        user = User.new(user_params)
        if user.save
            render json: {status: 200, message: "success", data: user}
        else
            render json: {status: 201, message: "failed", error: user.errors}
        end
    end
    private
    def user_params
        params.require(:user).permit(:name, :username, :password, :mobile_number)
    end
end
