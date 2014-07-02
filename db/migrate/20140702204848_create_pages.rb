class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url
      t.string :title
      t.references :category, index: true

      t.timestamps
    end
  end
end
