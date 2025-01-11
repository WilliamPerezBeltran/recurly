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
        result  
      end

      private 
      def validate_length(format, expected_length)
        format.count("NAX") == expected_length
      end




    end
  end
end
