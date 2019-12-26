class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.text :payload
      t.belongs_to :match

      t.timestamps
    end
  end
end
