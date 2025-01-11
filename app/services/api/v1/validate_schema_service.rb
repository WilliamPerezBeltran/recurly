# frozen_string_literal: true

module Api
  module V1
    class ValidateSchemaService
      include StructureSchema
      attr_accessor :data_schema, :type

      TYPE = %w[normal business].freeze

      def initialize(data_schema, type)
        @data_schema = data_schema
        @type = type
      end

      def valid_schema?
        return false unless TYPE.include?(@type)

        structure = StructureSchema.get_schema_structure(@type)
        p structure
        JSON::Validator.validate(structure, @data_schema)
      end
    end
  end
end
