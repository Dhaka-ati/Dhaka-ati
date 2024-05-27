# app/controllers/api/v1/base.rb
module Api
  module V1
    class Base  < Grape::API
    include Grape::Kaminari
    include Api::V1::Helpers::ErrorHandler
    # include ErrorHundle
    # include Constants

    # Helpers to send success or failure message to frontend
    # helpers Admin::QueryParams::StaffParams

    #############################
    # Prefix and Formatting
    #############################
    format :json
    prefix :public_library
    formatter :json, Grape::Formatter::Json

    #############################
    # Authorization
    #############################
    before do
       # ActiveStorage::Current.host = request.base_url
      auth_optional = route&.settings&.dig(:authentication, :optional)
      if auth_optional
        auth_key = ApiToken.find_by(token: bearer_token)
        if auth_key.present? && auth_key.expired_at <= DateTime.now && auth_key.active?
          @current_user = User.find_by(id: auth_key.user_id)
        else
          Rails.logger.info 'Authentication optional for this endpoint'
        end
      else
        error!('401 Unauthorized', 401) unless authenticated!
      end

    end

    helpers do
      def authenticated!
        auth_key = ApiToken.find_by(token: bearer_token)
        if auth_key.present? && auth_key.expired_at > DateTime.now
          @current_user = auth_key.user
        else
          error!('Unauthorized', 401)
        end
      rescue StandardError => e
        Rails.logger.error "Authentication failed due to: #{e.message}"
        error!('Unauthorized', 401)
      end

      def bearer_token
        request.headers.fetch('authorization', '').split(' ').last
      end

      def set_user_agent
        @request_user_agent = request.headers.fetch('User-Agent')
      end

    end

    mount Api::V1::Books
    mount Api::V1::UserAuths
    mount Api::V1::Rooms
    mount Api::V1::Profiles
  end
  end
end
