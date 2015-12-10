class AddNameIndexToCategories < ActiveRecord::Migration
  def change
    add_index :categories, :name, unique: true
  end
end
