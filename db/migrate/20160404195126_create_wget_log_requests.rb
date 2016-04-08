class CreateWgetLogRequests < ActiveRecord::Migration
  def change
    create_table :wget_log_requests do |t|
      t.references :wget_log, index: true
      t.datetime :requested_at
      t.string :url
      t.string :host
      t.string :ip_v4
      t.string :ip_v6
      t.integer :port
      t.integer :response_code
      t.boolean :is_redirect
      t.string :redirect_location
      t.integer :specified_length, default: 0
      t.string :specified_mime_type
      t.string :saved_path
      t.integer :saved_length
      t.string :download_speed

      t.timestamps
    end
  end
end
