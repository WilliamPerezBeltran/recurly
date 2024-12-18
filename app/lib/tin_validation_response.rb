# frozen_string_literal: true

# This module provides methods and responses for TIN validation processes.
#  defining standardized structures
module TinValidationResponse
  # This methods are responsibles for validation response.

  def valid_response(valid, tin_type, country_code, tin_number)
    {
      properties: {
        valid: {
          type: 'Boolean',
          value: valid
        },
        tin_type: {
          type: 'string',
          enum: tin_type
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
          items: [],
          message: 'Tin is valid'
        }

      }
    }
  end

  def invalid_response(valid, _tin_type, country_code, tin_number, errors)
    {
      properties: {
        valid: {
          type: 'Boolean',
          value: valid
        },
        tin_number: {
          type: 'string',
          value: tin_number
        },
        formatted_tin: {
          type: 'string',
          country: country_code
        },
        errors: {
          type: 'array',
          items: errors,
          message: 'Tin is invalid'
        }
      }
    }
  end
end
