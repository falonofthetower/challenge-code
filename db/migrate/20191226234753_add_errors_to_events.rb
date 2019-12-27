class AddErrorsToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :json_errors, :string
  end
end
