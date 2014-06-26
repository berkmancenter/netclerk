class AddIso2ToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :iso2, :string
  end
end
