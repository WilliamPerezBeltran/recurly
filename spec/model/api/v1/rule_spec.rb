require 'rails_helper'

RSpec.describe Rule, type: :model do
  context 'validations' do
    it 'should be valid with correct attributes' do
      rule = Rule.create(
        country: 'australia',
        iso: 'au',
        tin_type: 'au_abn',
        tin_name: 'australian business number',
        format: 'NN NNN NNN NNN',
        example: '10 120 000 004',
        format_length: 11
      )
      expect(rule).to be_valid
    end

    it 'should be invalid without a country' do
      rule = Rule.create(
        iso: 'au',
        tin_type: 'au_abn',
        tin_name: 'australian company number',
        format: 'NNN NNN NNN',
        example: '101 200 000',
        format_length: 9
      )
      expect(rule).to be_valid
    end

    it 'should be invalid without a country' do
      rule = Rule.create(
        iso: 'in',
        tin_type: 'in_gst',
        tin_name: 'indian gst numbe',
        format: 'NNXXXXXXXXXXNAN',
        example: '123456789RT0001',
        format_length: 15
      )
      expect(rule).to be_valid
    end
  end
end


