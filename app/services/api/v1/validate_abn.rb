# frozen_string_literal: true

require 'rexml/document'

module Api
  module V1
    # This class is responsible for validating ABN numbers.
    class ValidateAbn
      API_BASE = 'http://localhost:8080/'

      def initialize(abn)
        @abn = abn
        @errors = []
      end

      def validate
        p validate_gst_status
        return { valid: false, errors: ['Abn must be 11 digist and numeric'] } unless valid_abn?

        @abn = @abn.chars.map(&:to_i)
        @abn[0] = @abn[0] - 1

        weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

        @abn.each_with_index do |value, position|
          @abn[position] = (value * weighting[position])
        end
        { valid: (@abn.sum % 89).zero?, errors: [] }
      end

      def validate_gst_status
        xml_data = Net::HTTP.get(URI("#{API_BASE}queryABN?abn=#{@abn}"))
        document = REXML::Document.new(xml_data)

        status = document.elements['//abn_response/response/businessEntity/status'].text
        gst = document.elements['//abn_response/response/businessEntity/goodsAndServicesTax'].text

        if status == 'Active ' && gst == 'true'
          { valid: true, errors: [] }
        else
          @errors << 'Status invalid' if status != 'Active'
          @errors << 'GST unregistered' if gst == 'false'

          { valid: false, errors: @errors }
        end
      rescue StandardError
        @errors << 'Error fetching data about the business regardless ABN provided'
        { valid: false, errors: @errors }
      end

      private

      def valid_abn?
        @abn.match?(/^\d{11}$/)
      end
    end
  end
end
