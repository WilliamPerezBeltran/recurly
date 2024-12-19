# frozen_string_literal: true

require 'pry'
require "net/http"

module Api
  module V1
    class TinsController < ApplicationController
			
			
      include TinValidationResponse
      before_action :preprocess_params, only: [:validation_tin, :validate_abn]

      def validation_tin
        tin_instance = Tin.new(@country_code, @tin_number)
        validation_service = TinValidationService.new(tin_instance.country, tin_instance.tin)
        result = validation_service.validate

        invalid_response(result[:valid], result[:tin_type], @country_code, @tin_number, 
                         result[:errors])
        if result[:valid]
          render json: valid_response(result[:valid],result[:tin_type],@country_code, @tin_number),
                 status: :ok
        else
          render json: invalid_response(
            result[:valid], result[:tin_type],@country_code,@tin_number,result[:errors]
          ),
                 status: :unprocessable_entity
        end
      end

      def validate_abn
        #{:validate_gst_status=>false, :errors=>["GST unregistered"]}


        abnInstance = ValidateAbn.new(@abn)
        validation = abnInstance.validate
        validation_gst = abnInstance.validate_gst_status
        # binding.pry


        if validation[:valid] && validation_gst[:valid]
        	render json: { valid: validation[:valid], message: 'ABN is valid'  }, status: :ok
        else
        	render json: { valid: validation[:valid], errors: validation[:errors].concat(validation_gst[:errors])}, status: :unprocessable_entity
          # render json: { valid: validation[:valid], errors: validation[:errors]+ validation_gst[:errors]}, status: :unprocessable_entity
        end
      end

			

      private

      def preprocess_params
        case action_name
        when 'validation_tin'
          @country_code = params[:country_code]
          @tin_number = params[:tin_number]
        when 'validate_abn'
          @abn = normalize_abn(params[:abn])
        end
      end

      def normalize_abn(abn)
        abn.delete(' ')
      end
    end
  end
end



