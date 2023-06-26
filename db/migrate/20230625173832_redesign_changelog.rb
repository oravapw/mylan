class RedesignChangelog < ActiveRecord::Migration[7.0]

  def up
    drop_table :changelogs

    create_table :changelogs do |t|
      t.datetime :timestamp, null: false
      t.string :change, null: false
      t.references :player, foreign_key: { on_delete: :nullify }
      t.references :tournament, foreign_key: { on_delete: :nullify }
    end
  end

  def down
    drop_table :changelogs

    create_table :changelogs do |t|
      t.integer :change_type, null: false
      t.string :oldvalues
      t.string :newvalues
      t.bigint :row_id
      t.timestamps
    end
  end

end
