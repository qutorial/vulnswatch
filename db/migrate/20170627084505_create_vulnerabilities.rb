class CreateVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :vulnerabilities do |t|
      t.string :name
      t.text :summary
      t.datetime :created
      t.datetime :modified

      t.timestamps
    end
  end
end
