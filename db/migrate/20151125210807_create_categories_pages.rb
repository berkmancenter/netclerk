class CreateCategoriesPages < ActiveRecord::Migration
  def change
    create_table :categories_pages, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :page, index: true
    end
  end
end
