class AddIndexesToBrands < ActiveRecord::Migration[6.1]
  def change
    add_index :brands, :name
  end
end
