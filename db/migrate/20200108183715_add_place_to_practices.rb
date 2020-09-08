class AddPlaceToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :place, :string
  end
end
