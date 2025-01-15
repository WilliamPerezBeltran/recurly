require 'rails_helper'

RSpec.describe Tin, type: :model do
  before do
    Rule.create(country: "australia", iso: "au", tin_type: "au_abn", tin_name: "australian business number", format: "NN NNN NNN NNN", format_length: 11, example: "10 120 000 004")
    Rule.create(country: "australia", iso: "au", tin_type: "au_acn", tin_name: "australian company number", format: "NNN NNN NNN", format_length: 9, example: "101 200 000")
    Rule.create(country: "canada", iso: "ca", tin_type: "ca_gst", tin_name: "canada gst number", format: "NNNNNNNNNRT0001", format_length: 9, example: "123456789RT0001")
    Rule.create(country: "india", iso: "in", tin_type: "in_gst", tin_name: "indian gst number", format: "NNXXXXXXXXXXNAN", format_length: 15, example: "123456789RT0001")
  end

  describe '#select_tin' do
    context 'when the country is Australia' do
      it 'returns the correct TIN data for au_abn with 11 digits' do
        tin = Tin.new('au', '10120000004')
        result = tin.select_tin
        expect(result).to include(
          country: 'australia',
          tin_type: 'au_abn',
          tin_name: 'australian business number',
          format: 'NN NNN NNN NNN',
          example: '10 120 000 004',
          iso: 'au',
          format_length: 11,
          type_structure: 'business'
        )
      end
    end

    context 'when the country is Canada' do
      it 'returns the correct TIN data for ca_gst' do
        tin = Tin.new('ca', '123456789RT0001')
        result = tin.select_tin
        expect(result).to include(
          country: 'canada',
          tin_type: 'ca_gst',
          tin_name: 'canada gst number',
          format: 'NNNNNNNNNRT0001',
          example: '123456789RT0001',
          iso: 'ca',
          format_length: 9,
          type_structure: 'normal'
        )
      end
    end

    context 'when the country is India' do
      it 'returns the correct TIN data for in_gst' do
        tin = Tin.new('in', '123456789RT0001')
        result = tin.select_tin
        expect(result).to include(
          country: 'india',
          tin_type: 'in_gst',
          tin_name: 'indian gst number',
          format: 'NNXXXXXXXXXXNAN',
          example: '123456789RT0001',
          iso: 'in',
          format_length: 15,
          type_structure: 'normal'
        )
      end
    end

    context 'when the country is not found' do
      it 'returns nil' do
        tin = Tin.new('us', '123456789')
        result = tin.select_tin
        expect(result).to be_nil
      end
    end

    context 'when the TIN number is formatted' do
      it 'formats the TIN correctly for an 11-digit number' do
        tin = Tin.new('au', '10120000004')
        result = tin.select_tin
        expect(result[:tin_given]).to eq('10 120 000 004')
      end

      it 'formats the TIN correctly for a 9-digit number' do
        tin = Tin.new('au', '101200000')
        result = tin.select_tin
        expect(result[:tin_given]).to eq('101 200 000')
      end
    end
  end
end
