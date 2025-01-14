# frozen_string_literal: true

# indicates the strtuctre schema it require to use
module StructureSchema
  @schema = {
    'type' => 'object',
    'required' => %w[valid tin_type formatted_tin errors],
    'properties' => {
      'valid' => {
        'type' => 'boolean'
      },
      'tin_type' => {
        'type' => 'string',
        'enum' => %w[au_abn au_acn ca_gst in_gst]
      },
      'formatted_tin' => {
        'type' => 'string'
      },
      'errors' => {
        'type' => 'array',
        'items' => {
          'type' => 'string'
        }
      }
    }
  }

  @schema2 = {
    'properties' => {
      'business_registration' => {
        'type' => 'object',
        'properties' => {
          'name' => {
            'type' => 'string'
          },
          'address' => {
            'type' => 'string'
          }
        }
      }
    }
  }
  # parameter normal or business
  def self.get_schema_structure(inst = 'normal')
    schema_copy = @schema.dup

    if inst == 'business'
      schema_copy['required'].push('business_registration')
      schema_copy['properties']['business_registration'] =
        @schema2['properties']['business_registration']
    end

    schema_copy
  end
end
