class CreateProxies < ActiveRecord::Migration
  def change
    create_table :proxies do |t|
      t.string :ip_and_port
      t.boolean :permanent
      t.references :country, index: true

      t.timestamps
    end
  end
end
