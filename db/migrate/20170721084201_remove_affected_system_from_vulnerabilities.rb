class RemoveAffectedSystemFromVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    begin
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
    rescue Exception => e
      puts " ERROR : Exception while moving the affected_system into tags"
      puts " But it may be normal when there is no such column "
      puts "Please refere to the error explained below"
      puts e.inspect
    end
    begin   
      remove_column :vulnerabilities, :affected_system, :string
    rescue Exception => e
      puts " ERROR : SQLite can not remove the column affected_system from vulnerabilities"
      puts e.inspect
      puts " NOTE  :  Please, do it manually"
    end
  end
end
