class RemovePreregField < ActiveRecord::Migration[7.0]
  def change
    remove_column :tournament_players, :prereg, null: false, default: false
  end
end
