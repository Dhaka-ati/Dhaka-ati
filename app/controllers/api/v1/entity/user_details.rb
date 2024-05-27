# frozen_string_literal: true

module Api
  module V1
    module Entity
    class UserDetails < Grape::Entity
      expose :id
      expose :name
      expose :email
      expose :rooms

      def rooms
        r = []
        owned_room = object.room
        r << { id: owned_room.id, title: owned_room.title, is_owned: true } if owned_room.present?
        member = object.members
        if member.present?
          member.each do |m|
            joined_room = Room.find_by(id: m.room_id)
            r << {
              id: joined_room.id,
              title: joined_room.title,
              is_owned: false
            }
          end

        end
        r
      end

      # def member
      #   member = object.members
      #   member.each do |r|
      #     {
      #       id: r.id,
      #       title: r.title,
      #       is_owned: false
      #     }
      #   end
      # end
    end
    end
  end
end
