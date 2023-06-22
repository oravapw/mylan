class AddTournamentPreregFields < ActiveRecord::Migration[7.0]

  def change
    add_column :tournaments, :prereg, :boolean, null: false, default: false
    add_column :tournaments, :prereg_slug, :string
    add_column :tournaments, :prereg_info, :text
    add_column :tournaments, :prereg_end, :datetime
    change_column :tournaments, :date, :datetime
  end

  def down
    remove_column :tournaments, :prereg
    remove_column :tournaments, :prereg_slug
    remove_column :tournaments, :prereg_info
    remove_column :tournaments, :prereg_end
    change_column :tournaments, :date, :date
  end
  
end
