class AddPageCountryDateIndexToStatuses < ActiveRecord::Migration
  def change
    add_index :statuses, [:page_id, :country_id, :created_at], unique: true
  end
end
