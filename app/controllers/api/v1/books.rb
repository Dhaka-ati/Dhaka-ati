# app/controllers/api/v1/books.rb
module Api
  module V1
    class Books < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api
      resource :books do
        desc 'Return all Books'
        get do
          books = Book.all
          present books
        end
      end
    end
  end
end