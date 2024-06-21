# app/controllers/api/v1/books.rb
module Api
  module V1
    class Rooms < V1::Base
      include Grape::Kaminari
      include Api::V1::Helpers::ErrorHandler
      version 'v1', using: :path
      format :json
      prefix :api
      resource :rooms do
        desc 'key list'
        params do
          use :pagination, max_per_page: 25
        end
        get 'key_list' do
          paginate(@current_user.room.invitation_keys) if @current_user.room.invitation_keys.present?
        end

        desc 'create room'
        params do
          requires :title, type: String, allow_blank: false
          requires :description, type: String, allow_blank: false
        end
        post do
          # error!('Already Created A Room', 403) if Room.find_by(user_id: @current_user.id)
          Room.create!(title: params[:title], description: params[:description], user_id: @current_user.id)
        end


      route_param :id do
        desc 'join room'
        params do
          requires :key, type: Integer, allow_blank: false
        end
        post 'join' do
          error!("Room Not Found", 404) unless InvitationKey.find_by(key: params[:key].to_s)&.room&.present?
          error!('You owned the room.', 400) if InvitationKey.find_by(key: params[:key])&.room&.id == @current_user&.room&.id
          error!('You have reached the max limit to join any room.', 403) if Member.where(user_id: @current_user.id).count >= 5
          error!('This Key is Invalid', 400) if InvitationKey.find_by(key: params[:key]).expire_at < DateTime.now
          Member.create(room_id: InvitationKey.find_by(key: params[:key]).room_id, user_id: @current_user.id)
        end


        end
      end
    end
  end
end
