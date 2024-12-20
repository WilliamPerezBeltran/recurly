require "rails_helper"

describe Api::V1::TinsController do 
  describe "routing" do 
    it "routes to #validation_tin" do 
      expect(:get => "/api/v1/country_code/CA/tin_number/123456789RT0001").to route_to(
        controller: "api/v1/tins",
        action: "validation_tin",
        country_code: "CA",
        tin_number: "123456789RT0001"
      )
    end
  end
end
