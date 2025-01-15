
require "rails_helper"

RSpec.describe Api::V1::TinValidationService, type: :service do
end
require 'rails_helper'
require 'net/http'
require 'rexml/document'

RSpec.describe Api::V1::TinValidationService, type: :service do
  let(:valid_au_tin) { '10120000004' }  
  let(:invalid_au_tin) { '1234567890' } 
  let(:country_code) { 'au' }

 

  describe '#validate_algorithm?' do
    context 'when the TIN passes the algorithm validation' do
      it 'returns true' do
        service = described_class.new('au', valid_au_tin)
        expect(service.validate_algorithm?).to be(true)
      end
    end

    context 'when the TIN fails the algorithm validation' do
      let(:invalid_au_tin) { '1234567890' }

      it 'returns false and adds an error' do
        service = described_class.new('au', invalid_au_tin)
        expect(service.validate_algorithm?).to be(false)
        expect(service.errors).to include('Abn is not valid')
      end
    end
  end

  describe '#validate_gst_status' do
    context 'when the business is valid and registered for GST' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(
          '<abn_response><response><businessEntity><status>Active</status><goodsAndServicesTax>true</goodsAndServicesTax><organisationName>Test Organization</organisationName><address><stateCode>NSW</stateCode><postcode>2000</postcode></address></businessEntity></response></abn_response>'
        )
      end

      it 'returns valid TIN GST status with organisation details' do
        service = described_class.new('au', valid_au_tin)
        result = service.validate_gst_status
        expect(result[:valid_tin_gst]).to be(true)
        expect(result[:organisation_name]).to eq('Test Organization')
        expect(result[:address]).to eq('NSW with postcode 2000')
      end
    end

    context 'when the business is not registered for GST' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(
          '<abn_response><response><businessEntity><status>Active</status><goodsAndServicesTax>false</goodsAndServicesTax><organisationName>Test Organization</organisationName><address><stateCode>NSW</stateCode><postcode>2000</postcode></address></businessEntity></response></abn_response>'
        )
      end

      it 'returns false for valid TIN GST status and adds an error' do
        service = described_class.new('au', valid_au_tin)
        result = service.validate_gst_status
        expect(result[:valid_tin_gst]).to be(false)
        expect(result[:organisation_name]).to eq('Test Organization')
        expect(result[:address]).to eq('NSW with postcode 2000')
        expect(service.errors).to include('GST unregistered')
      end
    end

    context 'when the business is not active' do
      before do
        allow(Net::HTTP).to receive(:get).and_return(
          '<abn_response><response><businessEntity><status>Inactive</status><goodsAndServicesTax>true</goodsAndServicesTax><organisationName>Test Organization</organisationName><address><stateCode>NSW</stateCode><postcode>2000</postcode></address></businessEntity></response></abn_response>'
        )
      end

      it 'returns false for valid TIN GST status and adds an error' do
        service = described_class.new('au', valid_au_tin)
        result = service.validate_gst_status
        expect(result[:valid_tin_gst]).to be(false)
        expect(result[:organisation_name]).to eq('Test Organization')
        expect(result[:address]).to eq('NSW with postcode 2000')
        expect(service.errors).to include('Status invalid')
      end
    end

    context 'when the API response is not valid' do
      before do
        allow(Net::HTTP).to receive(:get).and_raise(StandardError.new("API request failed"))
      end

      it 'returns false and adds an error' do
        service = described_class.new('au', valid_au_tin)
        result = service.validate_gst_status
        expect(result[:valid_tin_gst]).to be(false)
        expect(result[:organisation_name]).to be_nil
        expect(result[:address]).to be_nil
        expect(service.errors).to include('business is not registered')
      end
    end
  end
end
