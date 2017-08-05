class Management < ApplicationRecord

  class ArgumentError < RuntimeError ; end  

  def self.delete_old_unused_vulnerabilities(date_threshold, force = false)
    if date_threshold.class != DateTime
      raise ArgumentError, "Not a DateTime passed to " + __method__.to_s
    end
    
    if date_threshold >= (DateTime.now - 4.months) and not force
      raise ArgumentError, "Trying to delete not so old records, use force if you really want it."
    end

    vulns_to_delete = Vulnerability.where('modified <= ?', date_threshold).includes(:tags).includes(:reactions)
    vulns_to_delete.find_each do |vuln|
      next if vuln.tags.count > 0
      next if vuln.reactions.count > 0
      next if User.any?(&->(user){RelevantVulnerability.affects_user?(vuln,user)})
      vuln.destroy!
    end

  end

end
