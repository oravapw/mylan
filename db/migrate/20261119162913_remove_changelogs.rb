# frozen_string_literal: true
class RemoveChangelogs < ActiveRecord::Migration[8.1]
  def up
    drop_table :changelogs
  end

  def down
    create_table :changelogs do |t|
      t.datetime :timestamp, null: false
      t.string :change, null: false
      t.references :player, foreign_key: { on_delete: :nullify }
      t.references :tournament, foreign_key: { on_delete: :nullify }
    end
  end
end
