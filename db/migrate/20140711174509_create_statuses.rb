class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.references :page, index: true
      t.references :country, index: true
      t.integer :value
      t.integer :delta

      t.timestamps
    end
  end
end
