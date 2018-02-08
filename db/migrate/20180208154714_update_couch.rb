class UpdateCouch < ActiveRecord::Migration[5.1]
  def change
    Couch.update_all_views
  end
end
