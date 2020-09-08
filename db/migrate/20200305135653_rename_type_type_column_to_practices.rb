class RenameTypeTypeColumnToPractices < ActiveRecord::Migration[5.2]
  def change
    rename_column :practices, :type, :kind
  end
end
