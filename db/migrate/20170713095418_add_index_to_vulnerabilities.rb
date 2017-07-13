class AddIndexToVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    add_index :vulnerabilities, :name, unique: true
  end
end
