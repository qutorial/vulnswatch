class RenameDescriptionFieldInProjects < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :description, :systems_description
  end
end
