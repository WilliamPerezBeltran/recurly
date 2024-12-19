require 'rails_helper'

RSpec.describe Api::V1::TinsController, type: :request do
  describe "GET /api/v1/country_code/:country_code/tin_number/:tin_number. With valid number" do
    let(:country_code) { "CA" }
    let(:tin_number) { "123456789RT0001" }

    context "when the TIN is valid" do
      before do
        allow_any_instance_of(Api::V1::TinValidationService).to receive(:validate).and_return(
          valid: true,
          tin_type: "ca_gst",
          errors: []
        )
      end

      it "returns a valid response with status 200" do
        get "/api/v1/country_code/#{country_code}/tin_number/#{tin_number}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
		    "properties"=> {
		        "valid"=> {
		            "type"=> "Boolean",
		            "value"=> true
		        },
		        "tin_type"=> {
		            "type"=> "string",
		            "enum"=> "ca_gst"
		        },
		        "formatted_tin"=> {
		            "type"=> "string",
		            "country"=> "CA"
		        },
		        "tin_number"=> {
		            "type"=> "string",
		            "value"=> "123456789RT0001"
		        },
		        "errors"=> {
		            "type"=> "array",
		            "items"=> [],
		            "message"=> ""
		        }
		    }
		})
      end
    end
  end
  #==

describe "GET /api/v1/country_code/:country_code/tin_number/:tin_number. With invalid number" do
    let(:country_code) { "CA" }
    let(:tin_number) { "123456789RT" }

    context "when the Tin is invalid" do
      before do
        allow_any_instance_of(Api::V1::TinValidationService).to receive(:validate).and_return(
          valid: false,
          tin_type: "ca_gst",
          errors: ["Does not match the format"]
        )
      end

	      it "Return a invalid response with status unprocessable_entity" do
	        get "/api/v1/country_code/#{country_code}/tin_number/#{tin_number}"
	        expect(response).to have_http_status(:unprocessable_entity)
	        expect(JSON.parse(response.body)).to eq({
			    "properties"=> {
			        "valid"=> {
			            "type"=> "Boolean",
			            "value"=> false
			        },
			        "tin_number"=> {
			            "type"=> "string",
			            "value"=> "123456789RT"
			        },
			        "formatted_tin"=> {
			            "type"=> "string",
			            "country"=> "CA"
			        },
			        "errors"=> {
			            "type"=> "array",
			            "items"=> [
			                "Does not match the format"
			            ],
			            "message"=> "Tin is invalid"
			        }
			    }
			})
	      end
	    end
    end
    #==

describe "GET /api/v1/country_code/:country_code/tin_number/:tin_number. With valid number" do
    let(:country_code) { "IN" }
    let(:tin_number) { "22BCDEF1G2FH1Z5" }

    context "when the Tin is invalid" do
      before do
        allow_any_instance_of(Api::V1::TinValidationService).to receive(:validate).and_return(
          valid: true,
          tin_type: "in_gst",
          errors: []
        )
      end

	      it "Return a valid response with status ok with country IN and number 22BCDEF1G2FH1Z5" do
	        get "/api/v1/country_code/#{country_code}/tin_number/#{tin_number}"
	        expect(response).to have_http_status(:ok)
				        expect(JSON.parse(response.body)).to eq({
			    "properties"=> {
			        "valid"=> {
			            "type"=> "Boolean",
			            "value"=> true
			        },
			        "tin_type"=> {
			            "type"=> "string",
			            "enum"=> "in_gst"
			        },
			        "formatted_tin"=> {
			            "type"=> "string",
			            "country"=> "IN"
			        },
			        "tin_number"=> {
			            "type"=> "string",
			            "value"=> "22BCDEF1G2FH1Z5"
			        },
			        "errors"=> {
			            "type"=> "array",
			            "items"=> [],
			            "message"=> ""
			        }
			    }
			})
	      end
	    end
    end
    #==

describe "GET /api/v1/country_code/:country_code/tin_number/:tin_number. With valid number" do
    let(:country_code) { "IN" }
    let(:tin_number) { "22BCDEF1G2FH1Z5" }

    context "when the Tin is invalid" do
      before do
        allow_any_instance_of(Api::V1::TinValidationService).to receive(:validate).and_return(
          valid: true,
          tin_type: "in_gst",
          errors: []
        )
      end
	      it "Return a valid response with status ok with country IN and number 22BCDEF1G2FH1Z5" do
	        get "/api/v1/country_code/#{country_code}/tin_number/#{tin_number}"
	        expect(response).to have_http_status(:ok)
				        expect(JSON.parse(response.body)).to eq({
			    "properties"=> {
			        "valid"=> {
			            "type"=> "Boolean",
			            "value"=> true
			        },
			        "tin_type"=> {
			            "type"=> "string",
			            "enum"=> "in_gst"
			        },
			        "formatted_tin"=> {
			            "type"=> "string",
			            "country"=> "IN"
			        },
			        "tin_number"=> {
			            "type"=> "string",
			            "value"=> "22BCDEF1G2FH1Z5"
			        },
			        "errors"=> {
			            "type"=> "array",
			            "items"=> [],
			            "message"=> ""
			        }
			    }
			})
	      end
	    end
    end
    #==

describe "GET /api/v1/country_code/:country_code/tin_number/:tin_number. With valid number" do
    let(:country_code) { "AU" }
    let(:tin_number) { "10 120 000 004" }

    context "when the Tin is valid" do
	      before do
	        allow_any_instance_of(Api::V1::TinValidationService).to receive(:validate).and_return(
	          valid: true,
	          tin_type: "au_abn",
	          errors: []
	        )
	      end

	      it "Return a valid response with status ok with country AU and number 10 120 000 004" do
			  get "/api/v1/country_code/#{country_code}/tin_number/#{CGI.escape(tin_number)}"
			  expect(response).to have_http_status(:ok)
			  expect(JSON.parse(response.body)).to eq({
			    "properties" => {
			      "valid" => {
			        "type" => "Boolean",
			        "value" => true
			      },
			      "tin_type" => {
			        "type" => "string",
			        "enum" => "au_abn"
			      },
			      "formatted_tin" => {
			        "type" => "string",
			        "country" => "AU"
			      },
			      "tin_number" => {
			        "type" => "string",
			        "value" => "10+120+000+004" 
			      },
			      "errors" => {
			        "type" => "array",
			        "items" => [],
			        "message" => ""
			      }
			    }
			  })
			end
	    end
    end
    #==

  describe "GET /api/v1/abn/:abn" do
    let(:abn) { "12345678901" }

    context "when the ABN is valid" do
      before do
        allow_any_instance_of(Api::V1::ValidateAbn).to receive(:validate).and_return(valid: true, error: nil)
      end

      it "returns a valid response with status 200" do
        get "/api/v1/abn/#{abn}"
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "valid" => true,
          "message" => "ABN is valid."
        })
      end
    end
  end
  #==

  describe "GET /api/v1/abn/:abn" do
    let(:abn) { "5 1 8 2 456" }

  
    context "when the ABN is invalid" do
      before do
        allow_any_instance_of(Api::V1::ValidateAbn).to receive(:validate).and_return(valid: false, error: "Invalid ABN")
      end

      it "returns an error response with unprocessable_entity" do
        get "/api/v1/abn/#{CGI.escape(abn)}"
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({
          "valid" => false,
          "error" => "Invalid ABN"
        })
      end
    end
  end
  #==
end
