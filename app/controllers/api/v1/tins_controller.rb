require 'pry'

module Api::V1
	class TinsController < ApplicationController
		before_action :preprocess_params, only: [:validation_tin, :validate_abn]

		def validation_tin 
			tin_instance = Tin.new(@country_code, @tin_number)
			validation_service  = TinValidationService.new(tin_instance.country,tin_instance.tin)
			result = validation_service.validate 
			render json: result
		end

		def validate_abn
			validate_abn = ValidateAbn.new(@abn)
  	result = validate_abn.validate
			render json: result
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
