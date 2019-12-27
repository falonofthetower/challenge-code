class AddMatchStatusToEvents < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE match_state AS ENUM ('successful', 'unchecked', 'missing', 'malformed');
    SQL
    add_column :events, :match_status, :match_state
  end

  def down
    remove_column :events, :match_status
    execute <<-SQL
      DROP TYPE match_state;
    SQL
  end
end
