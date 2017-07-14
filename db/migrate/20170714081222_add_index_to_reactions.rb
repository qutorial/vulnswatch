class AddIndexToReactions < ActiveRecord::Migration[5.1]
  def change
    add_index :reactions, [:vulnerability_id, :user_id], unique: true
  end
end
