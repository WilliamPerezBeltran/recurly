Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "country_code/:country_code/tin_number/:tin_number", to: "tins#validationTin"
    end
  end
end
