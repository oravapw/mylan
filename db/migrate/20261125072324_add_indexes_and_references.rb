class AddIndexesAndReferences < ActiveRecord::Migration[8.1]
  def up
    remove_index :tournament_players, :tournament_id
    add_index :tournament_players, [:tournament_id, :player_id], unique: true
    
    # clean up possible old crud
    Player.where(email: '').update_all(email: nil)

    # if this throws an error on migration, you'll need to weed out duplicates
    # in DB by hand
    add_index :players, :email, unique: true

    add_foreign_key :tournament_players, :players
    add_foreign_key :tournament_players, :tournaments
  end

  def down
    remove_index :tournament_players, [:tournament_id, :player_id]
    add_index :tournament_players, :tournament_id

    remove_index :players, :email

    remove_foreign_key :tournament_players, :players
    remove_foreign_key :tournament_players, :tournaments
  end
end
