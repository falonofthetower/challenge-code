class AddCheckedToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :checked, :boolean, default: false
  end
end
