class AddProxiesToTournaments < ActiveRecord::Migration[7.0]
  def change
    add_column :tournaments, :proxies, :boolean, null: false, default: false
  end
end
