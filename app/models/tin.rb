# Represents a Tax Identification Number (TIN) for a specific country.
class Tin
  attr_accessor :country, :tin, :errors

  def initialize(country, tin)
    @country = country
    @tin = tin
    @errors = []
  end

  def select_tin
    data = Rule.where(iso: @country).find do |item|
      case item.iso
      when 'au'
        data = item if item.format_length == 11 || item.format_length == 9
      when 'ca', 'in'
        data = item
      end
    end
    return nil unless data

    {
      country: data.country,
      tin_type: data.tin_type,
      tin_name: data.tin_name,
      format: data.format,
      example: data.example,
      iso: data.iso,
      format_length: data.format_length,
      tin_given: format_number(@tin),
      type_structure: @tin.length == 11 ? 'business' : 'normal'

    }
  end

  private

  def format_number(number)
    case number.length
    when 11
      number.gsub(/(\d{2})(\d{3})(\d{3})(\d{3})/, '\1 \2 \3 \4')
    when 9
      number.gsub(/(\d{3})(\d{3})(\d{3})/, '\1 \2 \3')
    else
      number
    end
  end
end
