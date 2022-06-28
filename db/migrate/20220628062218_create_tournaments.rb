class CreateTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :tournaments do |t|
      t.string :name, limit: 40, null: false
      t.string :location, limit: 80
      t.string :organizers, limit: 120
      t.date :date
      t.boolean :decklists, null: false, default: false
      t.text :notes

      t.timestamps
    end
  end
end
