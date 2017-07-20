class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :component
      t.references :vulnerability, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
