# frozen_string_literal: true

require 'net/http'
require 'pry'

module Api
  module V1
    class TinsController < ApplicationController
      before_action :preprocess_params, only: [:validation_tin]

      def validation_tin
        # tin_instance = Tin.new(@country_code, @tin_number)
        # validation_service = TinValidationService.new(tin_instance.country, tin_instance.tin)
        # result = validation_service.validate
        


        validation_structure_schema = ValidateSchemaService.new(data, type)
        p validation_structure_schema.valid_schema?

        
        render json:  validation_structure_schema.valid_schema? 
        # render json: result 
      end

      private

      def preprocess_params
        case action_name
        when 'validation_tin'
          @country_code = params[:country_code]
          @tin_number = params[:tin_number]
        end
      end
    end
  end
end



