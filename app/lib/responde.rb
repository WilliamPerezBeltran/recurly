# frozen_string_literal: true

# This module provides methods and responses for TIN validation processes.
#  defining standardized structures
module Responde
  # This methods are responsibles for validation response.

  def responde(valid, tin_type, formatted_tin, tin_number, errors)
    {
      properties: {
        valid: valid,
        tin_type: tin_type,
        formatted_tin: formatted_tin,
        tin_number: {
          type: 'string',
          value: tin_number
        },
        errors: errors
      }
    }
  end

  def responde_gsp(valid, tin_type, formatted_tin, tin_number, obj)
    {
      properties: {
        valid: valid,
        tin_type: tin_type,
        formatted_tin: formatted_tin,
        tin_number: {
          type: 'string',
          value: tin_number
        },
        errors: obj[:errors],
        business_registration: {
          type: 'object',
          properties: {
            name: {
              type: 'string',
              value: obj[:organisation_name]
            },
            address: {
              type: 'string',
              value: obj[:address]
            }
          }
        }
      }
    }
  end
end
