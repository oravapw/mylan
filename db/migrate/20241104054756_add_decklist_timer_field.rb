class AddDecklistTimerField < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :decklist_delay, :integer, null: false, default: 0
  end
end
