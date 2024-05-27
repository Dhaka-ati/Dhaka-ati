# app/controllers/api/v1/books.rb
module Api
  module V1
    class Profiles < V1::Base
      include Grape::Kaminari
      include Api::V1::Helpers::ErrorHandler
      version 'v1', using: :path
      format :json
      prefix :api
      resource :profiles do
        desc 'profile details current user'
        get do
          Api::V1::Entity::UserDetails.represent(@current_user)
        end
    end
  end
  end
end

