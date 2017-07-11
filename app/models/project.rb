require 'set'

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
    lines = systems_description.gsub(/#.*$/, '').gsub(/\n+|\r+/,"\n").squeeze("\n").gsub(/^\s+/,'').gsub(/\s+$/,'').split("\n")
    res = Set.new
    lines.each do |line|
      line.split(',').each do |sys|
        # remove repeating spaces and leading and trailing spaces
        sys = sys.gsub(/\s+/,' ').gsub(/^\s+/,'').gsub(/\s+$/,'')
        res.add(sys)
      end
    end
    return res.to_a
  end

end
