require 'will_paginate/array'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to main_app.root_url, notice: exception.message }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
  end  

  rescue_from ActiveRecord::RecordNotFound do |exception|
      respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to main_app.root_url, notice: exception.message }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
  end  

  def alert_on_huge_projects
    current_user.projects.each do |project|
      if RelevantVulnerability.is_a_huge_project?(project)
        flash[:alert] = "The #{project.name} project is to big, we support #{RelevantVulnerability.many_systems} systems only."
      end
    end
  end
end
