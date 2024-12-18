# frozen_string_literal: true

module Api
  module V1
    # This class is responsible for validating ABN numbers.
    class ValidateAbn
      def initialize(abn)
        @abn = abn
      end

      def validate
        return { valid: false, error: 'Abn must be 11 digist and numeric ' } unless valid_abn?

        @abn = @abn.chars.map(&:to_i)
        @abn[0] = @abn[0] - 1

        weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

        @abn.each_with_index do |value, position|
          @abn[position] = (value * weighting[position])
        end
        { valid: (@abn.sum % 89).zero? }
      end

      private

      def valid_abn?
        @abn.match?(/^\d{11}$/)
      end
    end
  end
end
