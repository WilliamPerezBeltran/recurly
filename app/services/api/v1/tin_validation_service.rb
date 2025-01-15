module Api
  module V1
    # This class is responsible for validating number.
    class TinValidationService
      API_BASE = "http://localhost:8080/"

      def initialize(country_code, tin_number)
        @country_code = country_code
        @tin_number = tin_number
        @errors = []
      end

      def validate_format?
        
          result = nil 
          Rule.where(iso: @country_code).each do |item|
            if validate_length(item.format, item.format_length)
              regex = case item.iso
                      when "au"
                        if item.format_length == 11
                          /^\d{2}\s\d{3}\s\d{3}\s\d{3}$|^\d{11}$/
                        elsif item.format_length == 9
                          /^\d{3}\s?\d{3}\s?\d{3}$/
                        end
                      when "ca"
                        /^\d{9}RT0001$/
                      when "in"
                        /^(\d{2})([A-Za-z0-9]{10})(\d)([A-Za-z]{1})(\d{1})$/
                      end

              result = @tin_number.match?(regex)
              break if result 
            end
          end

          @errors << "Invalid format or length" if [false, nil].include?(result) 
          result  
      rescue StandardError => e
          @errors << "Invalid country code"
          @errors << e
          false
        
      end

      def validate_algorithm?

        number = @tin_number.delete(" ").chars.map(&:to_i)
        number[0] = number[0] - 1

        weighting = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

        number.each_with_index do |value, position|
          number[position] = (value * weighting[position])
        end
        @errors << "Abn is not valid" unless (number.sum % 89).zero?
        (number.sum % 89).zero?
      end

      def validate_gst_status
           begin 
           xml_data = Net::HTTP.get(URI("#{API_BASE}queryABN?abn=#{@tin_number}"))
           document = REXML::Document.new(xml_data)

           status = document.elements["//abn_response/response/businessEntity/status"].text
           gst = document.elements["//abn_response/response/businessEntity/goodsAndServicesTax"].text
           organisation_name = document.elements["//abn_response/response/businessEntity/organisationName"].text
           state_code = document.elements["//abn_response/response/businessEntity/address/stateCode"].text
           postcode = document.elements["//abn_response/response/businessEntity/address/postcode"].text
           address = "#{state_code} with postcode #{postcode}"
           rescue StandardError 
             @errors << "business is not registered"
             return { valid_tin_gst: false, organisation_name: nil, address: nil }
           end
           valid_tin = status == "Active" && gst == "true"
           @errors << "Status invalid" if status != "Active"
           @errors << "GST unregistered" if gst == "false"
           { valid_tin_gst: valid_tin, organisation_name: organisation_name, address: address }
       
      rescue StandardError => e
         @errors << e
         { valid_tin_gst: false, organisation_name: nil, address: nil }
         
      end

      attr_reader :errors

      private 
      
      def validate_length(format, expected_length)
        format.count("NAX") == expected_length
      end
    end
  end
end
