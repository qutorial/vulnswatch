class CreateNvdUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :nvd_updates do |t|
      t.datetime :last

      t.timestamps
    end
  end
end
