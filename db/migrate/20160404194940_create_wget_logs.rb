class CreateWgetLogs < ActiveRecord::Migration
  def change
    create_table :wget_logs do |t|
      t.string :warc_path
      t.datetime :finished_at
      t.string :total_time
      t.integer :file_count
      t.string :download_time

      t.timestamps
    end
  end
end
