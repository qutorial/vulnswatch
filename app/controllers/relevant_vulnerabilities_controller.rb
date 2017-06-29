require 'set'

class RelevantVulnerabilitiesController < ApplicationController

  def index
    all_projects = current_user.projects

    systems = Set.new
    
    all_projects.each do |project|
      systems.merge(project.systems)
    end

    condition = ''
    systems.each do |system|
      newpart = 'summary LIKE ?'
      condition =  condition.empty? ? newpart : condition + ' OR ' + newpart
    end    

    @relevant_vulnerabilities = Vulnerability.where('summary LIKE ?', "%#{systems.first.to_s}%").order(modified: :desc).paginate(page: params[:page])
    
  end

end
