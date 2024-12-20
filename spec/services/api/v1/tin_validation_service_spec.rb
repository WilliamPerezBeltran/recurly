# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::TinValidationService, type: :service do
  describe "#initialize" do
    it "initializes with a country code and TIN number" do
      service = described_class.new("AU", "123456789")
      expect(service.instance_variable_get(:@country_code)).to eq("AU")
      expect(service.instance_variable_get(:@tin_number)).to eq("123456789")
    end
  end

  describe "#validate_length" do
    let(:service) { described_class.new("AU", "123456789") }

    it "returns true for valid lengths" do
      expect(service.send(:validate_length, "NN NNN NNN NNN", 11)).to be true
    end

    it "returns false for invalid lengths" do
      expect(service.send(:validate_length, "NN NNN NNN NNN", 10)).to be false
    end
  end

  describe "#validate_format" do
    let(:service) { described_class.new("AU", "123456789") }

    it "returns true for matching regex" do
      expect(service.send(:validate_format, "123456789", /\A\d{9}\z/)).to be true
    end

    it "returns false for non-matching regex" do
      expect(service.send(:validate_format, "AB1234567", /\A\d{9}\z/)).to be false
    end
  end

  describe "#validate_algorithm?" do
    it "returns true for valid TIN numbers" do
      service = described_class.new("AU", "51824753556") # Example valid ABN
      expect(service.validate_algorithm?).to be true
    end

    it "returns false for invalid TIN numbers" do
      service = described_class.new("AU", "12345678901")
      expect(service.validate_algorithm?).to be false
    end


  end

end
