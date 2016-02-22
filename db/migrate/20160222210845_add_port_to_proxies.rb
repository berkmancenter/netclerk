class AddPortToProxies < ActiveRecord::Migration
  def change
    rename_column :proxies, :ip_and_port, :ip
    add_column :proxies, :port, :integer
  end
end
