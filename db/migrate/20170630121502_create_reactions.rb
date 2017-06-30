class CreateReactions < ActiveRecord::Migration[5.1]
  def change
    create_table :reactions do |t|
      t.references :user, foreign_key: true
      t.references :vulnerability, foreign_key: true
      t.integer :status
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
