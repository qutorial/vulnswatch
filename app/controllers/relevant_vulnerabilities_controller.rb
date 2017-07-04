class RelevantVulnerabilitiesController < ApplicationController

  def index
    @relevant_vulnerabilities = RelevantVulnerability.relevant_vulnerabilities(current_user).paginate(page: params[:page])    
  end

end
