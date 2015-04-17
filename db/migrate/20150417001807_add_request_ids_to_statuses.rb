class AddRequestIdsToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :request_ids, :text, array: true, default: []
  end
end
