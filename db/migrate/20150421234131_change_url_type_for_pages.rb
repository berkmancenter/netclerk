class ChangeUrlTypeForPages < ActiveRecord::Migration
  def up
    change_column :pages, :url, :text
  end

  def down
    change_column :pages, :url, :string
  end
end
