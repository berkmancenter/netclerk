class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.references :page, index: true
      t.references :country, index: true
      t.references :proxy, index: true
      t.string :unproxied_ip
      t.string :proxied_ip
      t.string :local_dns_ip
      t.integer :response_time
      t.integer :response_status
      t.text :response_headers
      t.integer :response_length
      t.float :response_delta

      t.timestamps
    end
  end
end
