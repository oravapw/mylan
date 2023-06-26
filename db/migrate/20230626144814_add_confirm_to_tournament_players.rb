class AddConfirmToTournamentPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :tournament_players, :confirmed, :boolean, null: false, default: false
  end
end
