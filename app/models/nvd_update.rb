class NvdUpdate < ApplicationRecord

  def self.register()
    NvdUpdate.create(last: DateTime.now)
  end

  def self.last()
    if NvdUpdate.all.count > 0
      return NvdUpdate.all.last.last.to_datetime
    else
      return DateTime.now.ago(20.years)
    end
  end

end
