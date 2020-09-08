class AddIncludesObogToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :includes_obog, :boolean, default: false
  end
end
