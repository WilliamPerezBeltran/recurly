# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TinsController, type: :controller do
  describe 'POST #validation_tin' do
    let(:valid_params) { { country_code: 'CA', tin_number: '123456789RT0001' } }
    let(:invalid_params) { { country_code: 'AU', tin_number: '10000000000' } }
    let(:mock_service) { instance_double(Api::V1::TinValidationService) }

    before do
      allow(Api::V1::TinValidationService).to receive(:new).and_return(mock_service)
    end

    context 'when the TIN is valid' do
      it 'returns a successful response with valid TIN data' do
        allow(mock_service).to receive(:validate).and_return({
          properties: {
            valid: true,
            tin_type: 'ca_gst',
            formatted_tin: 'NNNNNNNNNRT0001',
            tin_number: {
              type: 'string',
              value: '123456789RT0001'
            },
            errors: []
          }
        })

        post :validation_tin, params: valid_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['properties']['valid']).to eq(true)
        expect(json_response['properties']['tin_type']).to eq('ca_gst')
      end
    end

    context 'when the TIN is invalid' do
      it 'returns an error response with invalid TIN data' do

        allow(mock_service).to receive(:validate).and_return({
		    properties: {
		        valid: false,
		        tin_type: "au_abn",
		        formatted_tin: "NN NNN NNN NNN",
		        tin_number: {
		            type: "string",
		            value: "10000000000"
		        },
		        errors: [
		            "GST unregistered"
		        ],
		        business_registration: {
		            type: "object",
		            properties: {
		                name: {
		                    type: "string",
		                    value: "Example Company Pty Ltd 2"
		                },
		                address: {
		                    type: "string",
		                    value: "NSW with postcode 2001"
		                }
		            }
		        }
		    }
		})

        post :validation_tin, params: invalid_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['properties']['valid']).to eq(false)
        expect(json_response['properties']['errors']).to include("GST unregistered")
      end
    end
  end
end
