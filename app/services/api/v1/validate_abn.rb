module Api
  module V1
    # This class is responsible for validating ABN numbers.
    class ValidateAbn
      def initialize(abn)
        @abn = abn
      end

      def validate
        @abn = @abn.chars.map(&:to_i)
        @abn[0] = @abn[0] - 1

        weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

        @abn.each_with_index do |value, position|
          @abn[position] = (value * weighting[position])
        end
        (@abn.sum % 89).zero?
      end
    end
  end
end
