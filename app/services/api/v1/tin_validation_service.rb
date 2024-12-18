# frozen_string_literal: true

module Api
  module V1
    # This class is responsible for validating number.
    class TinValidationService
      include TinRules

      def initialize(country_code, tin_number)
        @country_code = country_code
        @tin_number = tin_number
        @errors = []
      end

      def validate
        matches = { AU: [:au_abn, :au_acn], CA: [:ca_gst], IN: [:in_gst] }.freeze
        # validate_country_name(@country_code.to_sym)

        unless TIN_FORMAT_RULES.keys.include?(@country_code.to_sym)
          @errors << ['ISO-3166 is not valid (country name is not valid)']
          return { valid: false, errors: @errors }
        end

        TIN_FORMAT_RULES[@country_code.to_sym].each do |key, value|
          next unless matches[@country_code.to_sym].include?(key)

          if @country_code == 'AU'
            TIN_FORMAT_RULES[:AU].each do |key, rule|
              if validate_format(@tin_number, rule[:regex]) && validate_length(rule[:format], rule[:length])
                return { valid: true, tin_type: key, errors: [] }
              end
            end
          end

          if validate_length(value[:format], value[:length]) && validate_format(@tin_number, value[:regex])
            return { valid: true, tin_type: key.to_s, errors: [] }
          else
            unless validate_format(@tin_number, value[:regex])
              @errors << 'Does not match the format'
            end
            unless validate_length(value[:format], value[:length])
              @errors << 'Error in format length'
            end
            return { valid: false, tin_type: key, country_code: @country_code, tin_number: @tin_number, errors: @errors }
          end
        end
      end

      private

      def validate_length(format, expected_length)
        format.count('NAX') == expected_length
      end

      def validate_format(format, regex)
        format.match? regex
      end
    end
  end
end
