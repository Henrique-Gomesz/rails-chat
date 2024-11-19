class UsersController < ApplicationController
  before_action :authorization_middleware, only: [ :show, :list ]

  def create
    user = User.new(user_params)
    if user.password.present?
      user.recovery_password = user.password
    end

    if user.save
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :bad_request
    end
  end

  def show
    user = current_user()
    render json: { user: { username: user.username, email: user.email } }, status: :ok
  end

  def list
    current_username = current_user.username
    usernames = User.where.not(username: current_username).pluck(:username)

    render json: { usernames: usernames }, status: :ok
  end

  private
    def user_params
      params.require(:user).permit(:email, :password, :username)
    end
end
