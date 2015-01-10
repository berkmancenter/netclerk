class ChangeRequestsResponseTimeToFloat < ActiveRecord::Migration
  def up
    change_column :requests, :response_time, :float
  end

  def down
    change_column :requests, :response_time, :integer
  end
end
