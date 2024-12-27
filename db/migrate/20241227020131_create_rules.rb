class CreateRules < ActiveRecord::Migration[7.1]
  def change
    create_table :rules do |t|
      t.string :country
      t.string :tin_type
      t.string :tin_name
      t.string :format
      t.string :example

      t.timestamps
    end
  end
end
