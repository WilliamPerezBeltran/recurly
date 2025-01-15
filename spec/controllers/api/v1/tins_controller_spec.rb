require 'rails_helper'

RSpec.describe Api::V1::TinsController, type: :controller do
  describe 'POST #validation_tin' do
    let(:valid_tin_number) { '10 120 000 004' }
    let(:invalid_tin_number) { '123456789' }    
    let(:country_code) { 'au' }
    
    context 'when the country code is invalid' do
      it 'returns invalid country code' do
        post :validation_tin, params: { country_code: 'invalid', tin_number: valid_tin_number }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['valid']).to eq(false)
        expect(json_response['errors']).to include('Invalid country code')
      end
    end

    context 'when the country code is valid but the TIN is invalid' do
      it 'returns invalid TIN' do
        post :validation_tin, params: { country_code: country_code, tin_number: invalid_tin_number }
        
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['valid']).to eq(false)
        expect(json_response['errors']).not_to be_empty
      end
    end

   
  end
end
