class AddJsonPayloadToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :json_payload, :jsonb, :null => false, :default => {}
    add_index  :events, :json_payload, using: :gin
  end
end
