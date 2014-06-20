class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name
      t.string :iso3
      t.string :local_dns

      t.timestamps
    end
  end
end
