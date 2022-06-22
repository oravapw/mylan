class CreateChangelogs < ActiveRecord::Migration[7.0]
  def change
    create_table :changelogs do |t|
      t.integer :change_type, null: false
      t.integer :player_type, null: false
      t.string :oldvalues
      t.string :newvalues

      t.timestamps
    end
  end
end
