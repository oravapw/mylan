class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name, null: false, limit: 40
      t.string :vekn, limit: 7, index: { unique: true }
      t.string :country, limit: 2

      t.timestamps
    end
  end
end
