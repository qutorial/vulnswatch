class Project < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true

  def systems()
    prepare_description
  end
  
  private
  
  #shall return a list of strings with subsystems out of description
  def prepare_description()
               #  remove comments  and consequitive empty lines   and  leading and trailing spaces the split
    description.gsub(/#.*$/, '').gsub(/\n+|\r+/,"\n").squeeze("\n").gsub(/^\s+/,'').gsub(/\s+$/,'').split("\n")
  end

end
