class AddFormatLengthToRule < ActiveRecord::Migration[7.1]
  def change
    add_column :rules, :format_length, :integer
  end
end
