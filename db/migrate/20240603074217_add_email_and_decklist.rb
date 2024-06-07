class AddEmailAndDecklist < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :email, :string
    add_column :tournament_players, :email, :string
    remove_column :tournament_players, :decklist, :boolean, null: false, default: false
    add_column :tournament_players, :decklist, :text
    add_column :tournament_players, :token, :string
    add_index :tournament_players, :token, unique: true
  end
end
