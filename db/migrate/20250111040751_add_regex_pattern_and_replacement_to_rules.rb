class AddRegexPatternAndReplacementToRules < ActiveRecord::Migration[7.1]
  def change
    add_column :rules, :regex_pattern, :string
    add_column :rules, :replacement, :string
  end
end
