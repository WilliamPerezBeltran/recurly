# frozen_string_literal: true

require 'net/http'
require 'pry'

module Api
  module V1
    class TinsController < ApplicationController
      before_action :preprocess_params, only: [:validation_tin]

      def validation_tin
        if Rule.where(iso: @country_code) == []
          data = {
            valid: false,
            tin_type: nil,
            formatted_tin: @tin_number,
            errors: ['Invalid country code']
          }
          render json: data
          return 
        end

        # selecciona el objecto a evaluar 
        tin_instance = Tin.new(@country_code, @tin_number)
        obj_selected = tin_instance.select_tin
        
        # valida los datos ingresados por el usuario         
        validation_service = TinValidationService.new(tin_instance.country, tin_instance.tin)
        format_ = validation_service.validate_format?
        errors = validation_service.errors

        obj_is_valid = format_ 

        data = {
          valid: obj_is_valid,
          tin_type: obj_selected[:tin_type],
          formatted_tin: obj_selected[:tin_given],
          errors: errors
        }

        if obj_selected[:iso] == 'au' && @tin_number.length == 11 && data[:valid] 
          validate_algorithm_ = validation_service.validate_algorithm?
          obj_algorithm = validation_service.validate_gst_status
          obj_is_valid = format_ && validate_algorithm_ && obj_algorithm[:valid_tin_gst]

          data[:valid] = obj_is_valid
          data[:errors] = errors
          data[:business_registration] = {}
          data[:business_registration][:name] = obj_algorithm[:organisation_name]
          data[:business_registration][:address] = obj_algorithm[:address]
        end

        # validation_structure_schema = ValidateSchemaService.new(data, obj_selected[:type_structure])

        # obj_is_valid = validation_structure_schema.valid_schema?

          render json: data 
      end

      private
      # def get_bussines_format(data, obj_is_valid,errors,obj_algorithm)
      #   data[:valid] = obj_is_valid
      #   data[:errors] = errors
      #   data[:business_registration] = {}
      #   data[:business_registration][:name] = obj_algorithm[:organisation_name]
      #   data[:business_registration][:address] = obj_algorithm[:address]
      #   data
        
      # end

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



