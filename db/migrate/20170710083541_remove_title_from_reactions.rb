class RemoveTitleFromReactions < ActiveRecord::Migration[5.1]
  def change
    remove_column :reactions, :title, :string
  end
end
