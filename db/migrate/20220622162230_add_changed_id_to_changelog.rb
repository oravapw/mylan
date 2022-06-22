class AddChangedIdToChangelog < ActiveRecord::Migration[7.0]
  def change
    add_column :changelogs, :row_id, :integer
  end
end
