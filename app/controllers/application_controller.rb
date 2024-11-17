class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_before_action :verify_authenticity_token

  # Authentication
  def encode_token(payload)
    JWT.encode(payload, Rails.application.secret_key_base, "HS256")
  end

  def decoded_token
    header = request.headers["Authorization"]
    if header
        token = header.split(" ")[1]
        begin
            JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
        rescue JWT::DecodeError
            nil
        end
    end
  end

  def current_user
    if decoded_token
        user_id = decoded_token[0]["user_id"]
        User.find_by(id: user_id)
    end
  end

  def authorization_middleware
    unless !!current_user
    render json: { message: "unauthorized" }, status: :unauthorized
    end
  end
end
