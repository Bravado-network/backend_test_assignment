class AddUnqiIndexesToTables < ActiveRecord::Migration[6.1]
  def change
    change_column_null :brands, :name, false
    change_column_null :cars, :model, false
  end
end
