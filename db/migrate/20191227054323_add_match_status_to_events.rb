class AddMatchStatusToEvents < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      CREATE TYPE match_status AS ENUM ('successful', 'unchecked', 'missing', 'malformed');
    SQL
    add_column :events, :match_status, :match_status
  end

  def down
    remove_column :events, :match_status
    execute <<-SQL
      DROP TYPE match_status;
    SQL
  end
end
