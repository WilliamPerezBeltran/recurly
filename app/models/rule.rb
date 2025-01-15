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
class Rule < ApplicationRecord
end
