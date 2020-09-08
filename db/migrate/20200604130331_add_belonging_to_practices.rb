class AddBelongingToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :belonging, :string
  end
end
