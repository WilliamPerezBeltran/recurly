Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "country_code/:country_code/tin_number/:tin_number", to: "tins#validation_tin"
      # get "abn/:abn/", to: "tins#validate_abn"
    end
  end
end
