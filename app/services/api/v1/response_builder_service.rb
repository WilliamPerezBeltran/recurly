module Api
  module V1
    # This class is responsible for construct the response object
    class ResponseBuilderService
      attr_accessor :response

      def initialize(valid,tin_type,formatted_tin,errors)
        @response =  { 
          valid: valid, 
          tin_type: tin_type, 
          formatted_tin: formatted_tin, 
          errors: errors 
        }
      end

      def business(business_info)
        @response[:business_registration] = business_info
      end

      def build
        @response        
      end

    end
  end
end
