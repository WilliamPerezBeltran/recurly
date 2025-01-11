# frozen_string_literal: true

module StructureSchema

  SCHEMA = {
    "type" => "object",
    "required" => ["valid", "tin_type", "formatted_tin", "errors"],
    "properties" => {
      "valid" => {
        "type" => "boolean"
      },
      "tin_type" => {
        "type" => "string",
        "enum" => ["au_abn", "au_acn", "ca_gst", "in_gst"]
      },
      "formatted_tin" => {
        "type" => "string"
      },
      "errors" => {
        "type" => "array",
        "items" => {
          "type" => "string"
        }
      }
    }
  }


  SCHEMA_2 = {
    "properties" => {
      "business_registration" => {
        "type" => "object",
        "properties" => {
          "name" => {
            "type" => "string"
          },
          "address" => {
            "type" => "string"
          }
        }
      }
    }
  }
  # parameter normal or business
  def self.get_schema_structure(inst = "normal")
    schema_copy = SCHEMA.dup

    if inst == "business"
      schema_copy["required"].push("business_registration")
      schema_copy["properties"]["business_registration"] = SCHEMA_2["properties"]["business_registration"]
    end

    schema_copy
  end
end
