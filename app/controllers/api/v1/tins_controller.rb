require 'pry'

module Api::V1
	class TinsController < ApplicationController
		def validationTin 
			validationService  = TinValidationService.new(params[:country_code],params[:tin_number])
			result = validationService.validate 
			render json: result
		end
	end
end

