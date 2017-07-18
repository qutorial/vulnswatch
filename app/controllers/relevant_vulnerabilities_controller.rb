class RelevantVulnerabilitiesController < ApplicationController

  def index()
    huge_projects = current_user.projects.select { 
       |project| RelevantVulnerability.is_a_huge_project?(project)} 
    
    huge_projects.each do |huge_project|
      flash[:alert] = "The project '#{huge_project.name}' is too big. Please, reduce the number of systems there.\n"
    end
 
   if RelevantVulnerability.has_too_many_systems?(current_user)
      flash[:alert] = "You have too many system in your projects. Please, reduce their count."
    end

    @relevant_vulnerabilities = RelevantVulnerability.all_relevant_vulnerabilities_for_user(current_user).paginate(page: params[:page])    

  end

end
