class CreateTournamentPlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :tournament_players do |t|
      t.string :name, limit: 40, null: false
      t.string :vekn, limit: 7
      t.boolean :decklist, null: false, default: false
      t.boolean :prereg, null: false, default: false
      t.bigint :player_id, null: false
      t.references :tournament, null: false
    end
  end
end
