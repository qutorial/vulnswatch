class RelevantVulnerabilitiesController < ApplicationController

  def index
    (current_user.projects.select { |project| project.huge? }).each do |huge_project|
      flash[:alert] = "The project '#{huge_project.name}' is too big. Please, reduce the number of systems there.\n"
    end
    @relevant_vulnerabilities = RelevantVulnerability.relevant_vulnerabilities(current_user).paginate(page: params[:page])    
  end

end
