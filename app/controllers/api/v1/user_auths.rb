# app/controllers/api/v1/books.rb
module Api
  module V1
    class UserAuths < V1::Base
      include Grape::Kaminari
      include Api::V1::Helpers::ErrorHandler
      version 'v1', using: :path
      format :json
      prefix :api

      resource :user_auths do

        desc 'Return all users'
        params do
         use :pagination, max_per_page: 25
        end
        get do
          users = User.all
          # present paginate(users.as_json(only: %i[id name email]))
          Api::V1::Entity::UserDetails.represent(paginate(users))
        end

        desc 'Login'
        params do
          requires :email, type: String, allow_blank: false, regexp: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          requires :password, type: String, allow_blank: false
        end
        route_setting :authentication, optional: true
        post 'login' do
          @user = User.find_by(email: params[:email])

          error!('Invalid email or password', 401) unless @user.present?
          error!('Invalid email or password', 401) unless @user&.authenticate(params[:password])

          api_token = ApiToken.create!(user: @user)
          { token: api_token.token, expired_at: api_token.expired_at }
        end

        desc 'Registration'
        params do
          requires :name, type: String, allow_blank: false
          requires :email, type: String, allow_blank: false, regexp: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
          requires :password, type: String, allow_blank: false
          requires :confirm_password, type: String, allow_blank: false, same_as: { value: :password, message: 'not match' }
        end
        route_setting :authentication, optional: true
        post 'registration' do
          user = User.create!(declared(params, include_missing: false).except(:confirm_password))
          present user.as_json(only: %i[id name email])
        end

        desc 'logout'
        delete 'logout' do
          token = request.headers.fetch('authorization', '').split(' ').last
          user = @current_user
          auth_key = ApiToken.find_by(token: token, user_id: user.id, active: true)
          auth_key.destroy! if auth_key.present?
          auth_key&.destroyed? || false
        end
      end
    end
  end
end
