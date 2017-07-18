class RelevantVulnerabilitiesController < ApplicationController

  def index()
    redirect_to vulnerabilities_path(project: 0)
  end

end
