class RemoveChangelogPlayerType < ActiveRecord::Migration[7.0]
  def change
    remove_column :changelogs, :player_type, :integer, null: false
  end
end
