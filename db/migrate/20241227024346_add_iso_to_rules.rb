class AddIsoToRules < ActiveRecord::Migration[7.1]
  def change
    add_column :rules, :iso, :string
  end
end
