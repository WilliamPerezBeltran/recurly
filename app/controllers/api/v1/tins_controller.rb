require 'pry'

module Api::V1
	class TinsController < ApplicationController
		def validationTin 
			tinInstance = Tin.new(params[:country_code],params[:tin_number])
			validationService  = TinValidationService.new(tinInstance.country,tinInstance.tin)
			result = validationService.validate 
			render json: result
		end
	end
end

