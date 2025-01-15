require 'net/http'
require 'pry'

module Api
  module V1
    class TinsController < ApplicationController
      before_action :preprocess_params, only: [:validation_tin]

      def validation_tin
        unless Rule.exists?(iso: @country_code)
          render json: invalid_country_response
          return 
        end

        tin_instance = Tin.new(@country_code, @tin_number)
        obj_selected = tin_instance.select_tin
        
        validation = TinValidationService.new(tin_instance.country, tin_instance.tin)
        errors = validation.errors

        obj_response = ResponseBuilderService.new(validation.validate_format?,obj_selected[:tin_type],obj_selected[:tin_given],errors)

        if au_business?(tin_instance,validation)
          obj_response.response[:valid] = validation.validate_format? && validation.validate_algorithm? && validation.validate_gst_status[:valid_tin_gst]
          obj_response.response[:errors] = errors
          obj_response.business({
            name: validation.validate_gst_status[:organisation_name],
            address: validation.validate_gst_status[:address]
          })
        end

        render json: obj_response.build 
      end

      private

      def au_business?(tin_instance,validation)
        tin_instance.select_tin[:iso] == 'au' && @tin_number.length == 11 && validation.validate_format?         
      end

      def invalid_country_response
        { 
          valid: false, 
          tin_type: nil, 
          formatted_tin: @tin_number,
          errors: ['Invalid country code'] 
        }
      end

      def preprocess_params
        case action_name
        when 'validation_tin'
					@country_code = params[:country_code].downcase
     @tin_number = params[:tin_number].strip.delete(' ')
        end
      end
    end
  end
end



