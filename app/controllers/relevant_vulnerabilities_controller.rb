class RelevantVulnerabilitiesController < ApplicationController

  def index
    systems = RelevantVulnerability.users_systems(current_user)
    conditions =['']
    systems.each do |system|
      newpart = 'summary LIKE ?'
      conditions[0] =  conditions[0].empty? ? newpart : conditions[0] + ' OR ' + newpart
      conditions.push "%#{system}%"
    end    
    
    @relevant_vulnerabilities = Vulnerability.where(conditions).order(modified: :desc).paginate(page: params[:page])
    
  end

end
