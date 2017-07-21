class RemoveAffectedSystemFromVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    vulns = Vulnerability.where("affected_system <> ''").where("affected_system IS NOT NULL")
    if vulns.count > 0
      puts "Detected vulnerabilities with affected system"
      user = User.first
      raise 'No user to assign tags to' if user.nil?
      vulns.each do |vuln|
        vuln.affected_system.split(',').each do |sys|
          sys = sys.gsub(/\s+/,' ').gsub(/^\s+/,'').gsub(/\s+$/,'').downcase
          next if sys.blank?
          tags = vuln.tags.where('LOWER(component) = ?', sys)
          if tags.count == 0
            tag = vuln.tags.build(user_id: user.id, component: sys)
            tag.save!
            puts "Built tag #{sys} for #{vuln.name} owned by #{user.name}"
          end
        end
        vuln.affected_system = ''
        vuln.save!
        puts "Cleared affected system in #{vuln.name}: #{vuln.affected_system.inspect}"
      end
    end
        
    remove_column :vulnerabilities, :affected_system, :string
  end
end
