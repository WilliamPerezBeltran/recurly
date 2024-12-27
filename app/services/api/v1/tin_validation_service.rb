# frozen_string_literal: true

module Api
  module V1
    # This class is responsible for validating number.
    class TinValidationService
      include TinRules
      # include Responde
      API_BASE = "http://localhost:8080/"

      def initialize(country_code, tin_number)
        @country_code = country_code
        @tin_number = tin_number
        @errors = []
      end

      def validate
        matches = { AU: [:au_abn, :au_acn], CA: [:ca_gst], IN: [:in_gst] }.freeze

        unless TIN_FORMAT_RULES.keys.include?(@country_code.to_sym)
          @errors << ["ISO-3166 is not valid (country name is not valid)"]
          return responde(false, "", "", @tin_number, @errors)
        end

        TIN_FORMAT_RULES[@country_code.to_sym].each do |key, value|
          next unless matches[@country_code.to_sym].include?(key)

          if @country_code == "AU"
            TIN_FORMAT_RULES[:AU].each do |key, rule|
              if validate_format(@tin_number, rule[:regex]) && validate_length(rule[:format], rule[:length])
                  if rule[:format] == "NN NNN NNN NNN" && validate_algorithm?
                     data = validate_gst_status
                     if data[:invalid_document]
                        return responde(!data[:invalid_document], "au_abn", rule[:format], @tin_number, data[:errors])
                     end
                     
                     obj = { organisation_name: data[:organisation_name], address: data[:address], errors: data[:errors] }

                     return responde_gsp(data[:valid_tin_gst], key, rule[:format], @tin_number, obj)
                  end
                  return responde(true, key, rule[:format], @tin_number, @errors)
              end
            end
          end
          if validate_length(value[:format], value[:length]) && validate_format(@tin_number, value[:regex])
          return responde(true, key,  value[:format], @tin_number, @errors)   

          else
          def handle_invalid_tin(key, value)
            validate_format_and_length(value)
            responde(false, key, value[:format], @tin_number, @errors)
          end
          end
        end
      end

      def validate_algorithm?

        number = @tin_number.delete(" ").chars.map(&:to_i)
        number[0] = number[0] - 1

        weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

        number.each_with_index do |value, position|
          number[position] = (value * weighting[position])
        end
        (number.sum % 89).zero?
      end

      def validate_gst_status
          
            xml_data = Net::HTTP.get(URI("#{API_BASE}queryABN?abn=#{@tin_number}"))
            document = REXML::Document.new(xml_data)

            begin 
            status = document.elements["//abn_response/response/businessEntity/status"].text
            gst = document.elements["//abn_response/response/businessEntity/goodsAndServicesTax"].text
            organisation_name = document.elements["//abn_response/response/businessEntity/organisationName"].text
            state_code = document.elements["//abn_response/response/businessEntity/address/stateCode"].text
            postcode = document.elements["//abn_response/response/businessEntity/address/postcode"].text
            address = "#{state_code} with postcode #{postcode}"
            rescue StandardError 
              return { invalid_document: true, errors: "invalid_document" }
            end
            valid_tin = status == "Active" && gst == "true"
            @errors << "Status invalid" if status != "Active"
            @errors << "GST unregistered" if gst == "false"
            { valid_tin_gst: valid_tin, gst: gst, organisation_name: organisation_name, state_code: state_code, 
              postcode: postcode, address: address, errors: @errors }
        
      rescue StandardError => e
          @errors << e
          { valid: false, errors: @errors }
          
      end

      private

      def validate_format_and_length(rule)
        @errors << "Does not match the format" unless validate_format(@tin_number, rule[:regex])
        @errors << "Error in format length" unless validate_length(rule[:format], rule[:length])
      end

      def validate_length(format, expected_length)
        format.count("NAX") == expected_length
      end

      def validate_format(format, regex)
        format.match? regex
      end
    end
  end
end
