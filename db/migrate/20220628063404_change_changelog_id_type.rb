class ChangeChangelogIdType < ActiveRecord::Migration[7.0]
  def up
    change_column :changelogs, :row_id, :bigint
  end

  def down
    change_column :changelogs, :row_id, :integer
  end
end
