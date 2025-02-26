module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        if current_user
          current_user
        else
          reject_unauthorized_connection
        end
      end

      def decoded_token
        token = request.params[:token]
            begin
                JWT.decode(token, Rails.application.secret_key_base, true, algorithm: "HS256")
            rescue JWT::DecodeError
                nil
            end
      end

      def current_user
        if decoded_token
            user_id = decoded_token[0]["user_id"]
            User.find_by(id: user_id)
        end
      end
  end
end
