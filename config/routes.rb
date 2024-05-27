Rails.application.routes.draw do

  mount Api::V1::Base => '/'
  # mount Api::Base => '/'
end
