class AddMatchStringToMatches < ActiveRecord::Migration[6.0]
  def change
    add_column :matches, :match_string, :text, index: true
  end
end
