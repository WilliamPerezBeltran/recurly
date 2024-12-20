# frozen_string_literal: true

# Represents a Tax Identification Number (TIN) for a specific country.
class Tin
  attr_accessor :country, :tin

  def initialize(country, tin)
    @country = country
    @tin = tin
  end
end
