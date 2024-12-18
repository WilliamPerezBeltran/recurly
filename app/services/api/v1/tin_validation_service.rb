module Api::V1
	class TinValidationService

	RULES = {
		AU: {
				au_abn: {
					format: "NN NNN NNN NNN",
					regex: /^\d{2} \d{3} \d{3} \d{3}$/,
					length: 11
				},
				au_acn: {
					format: "NNN NNN NNN",
					regex: /^\d{3} \d{3} \d{3}$/,
					length: 9 
				}
		},

		CA: {
			ca_gst: {
				format: "NNNNNNNNNRT0001",
				regex: /^\d{9}RT0001$/,
				length: 9 
			}
		},

		IN: {
			in_gst: {
				format: "NNXXXXXXXXXXNAN",
				regex: /^(\d{2})([A-Za-z0-9]{10})(\d)([A-Za-z]{1})(\d{1})$/,
				length: 15 
			}
		}

	}.freeze

	def initialize(country_code,tin_number)
		@country_code = country_code
		@tin_number = tin_number
		@errors = []
	end

	def validate

		matches = {
		  AU: [:au_abn, :au_acn],
		  CA: [:ca_gst],
		  IN: [:in_gst]
		}.freeze

		if !RULES.keys.include?(@country_code.to_sym)
			@errors << ["ISO-3166 is not valid (country name is not valid)"]
			return invalid_response(@country,@errors)
		end

		RULES[@country_code.to_sym].each do  |key, value|

			if matches[@country_code.to_sym].include?(key)
				if @country_code == "AU"
				  RULES[:AU].each do |key, rule|
				    if validate_format(@tin_number, rule[:regex]) && validate_length(rule[:format], rule[:length])
				      return valid_response(key, @country_code, @tin_number)
				    end
				  end
				end

				if validate_length(value[:format],value[:length]) and validate_format(@tin_number,value[:regex])
					return valid_response(key.to_sym,@country_code,@tin_number)
				else
					@errors << "Does not match the format" unless validate_format(@tin_number,value[:regex])
					@errors << "Error in format length" unless validate_length(value[:format],value[:length])
					return invalid_response(@country_code,@errors)
				end
			end 

		end

	end

	private
	def validate_length(format,expected_length)
	  format.count("NAX") == expected_length
	end

	def validate_format(format,regex)
	  format.match?regex
	end

	def valid_response(key,country_code,tin_number)
		{
		  properties: {
		    valid: {
		      type: 'Boolean',
		      value: true
		    },
		    tin_type: {
		      type: 'string',
		      enum: key
		    },
		    formatted_tin: {
		      type: 'string',
		      country: country_code
		    },
		    tin_number: {
		      type: 'string',
		      value: tin_number
		    },
		    errors: {
		      type: 'array',
		      items: [
		        
		      ]
		    },
		    
		  }
		}
	end

	def invalid_response(country,errors)
		{
		  properties: {
		    valid: {
		      type: 'Boolean',
		      value: false
		    },
		    formatted_tin: {
		      type: 'string',
		      country: country
		    },
		    errors: errors
		  }
		}
	end
end

end











