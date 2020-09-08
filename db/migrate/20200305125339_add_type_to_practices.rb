class AddTypeToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :type, :integer, default: 0
  end
end
