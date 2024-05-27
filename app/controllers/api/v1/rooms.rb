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
        end
        post do
          error!('Already Created A Room', 403) if Room.find_by(user_id: @current_user.id)
          Room.create!(title: params[:title], user_id: @current_user.id)
        end

        desc 'create invitation'
        params do
          requires :active_days, type: Integer, allow_blank: false
        end
        post 'add_key' do
          error!('User Do Not Have Any Room', 404) unless @current_user.room.present?
          error!('Max member has reached', 403) unless @current_user.room.invitation_keys.count < 5
          InvitationKey.create(room_id: @current_user.room.id, expire_at: DateTime.now+params[:active_days].days)
        end

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

        desc 'Delete owned room'
        delete 'delete' do
          error!("No Room Found", 404) unless @current_user.room.present?
          @current_user.room.destroy!
          { message: "Delete Successful" }
        end

        desc 'Delete invitation key'
        params do
          requires :key, type: Integer, allow_blank: false
        end
        delete 'remove_key' do
          error!("No Key Found", 404) unless @current_user&.room&.invitation_keys&.find_by(key: params[:key]).present?
          InvitationKey.find_by(key: params[:key]).destroy!
          { message: "Delete Successful" }
        end

      end
    end
  end
end
