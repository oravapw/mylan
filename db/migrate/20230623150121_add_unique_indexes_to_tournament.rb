class AddUniqueIndexesToTournament < ActiveRecord::Migration[7.0]
  def change
    add_index :tournaments, :name, unique: true
    add_index :tournaments, :prereg_slug, unique: true
  end
end
