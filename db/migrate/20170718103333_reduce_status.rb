class ReduceStatus < ActiveRecord::Migration[5.1]
  def change
    Reaction.all.each do |reaction|
      if reaction.status >= 2
        reaction.status = reaction.status - 1 
      else
        reaction.status = 2
      end
      
      reaction.save!
    end
  end
end
