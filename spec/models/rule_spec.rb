# == Schema Information
#
# Table name: rules
#
#  id         :integer          not null, primary key
#  country    :string
#  tin_type   :string
#  tin_name   :string
#  format     :string
#  example    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Rule, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
