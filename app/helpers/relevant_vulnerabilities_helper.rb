require 'set'

 module RelevantVulnerabilitiesHelper
  def why_relevant(vulnerability, user)
    res = ''
    RelevantVulnerability.affected_systems(vulnerability, user).each do |system|
      res += (res.empty? ? '' : '<br/> and ') + 
            String.new(h(system)) + 
            " in " + 
                    RelevantVulnerability.projects_having_system(system, user)
                                  .map(  &->(p){ link_to p.name, p } )
                            .join(' and in ')
    end
    return res unless res.empty?
    return '-'
  end
 end
