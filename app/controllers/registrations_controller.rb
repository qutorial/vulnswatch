class RegistrationsController < Devise::RegistrationsController
  @@no_registrations_message = 'Registration is not available at the moment'
  def new
    flash[:alert] = @@no_registrations_message
    redirect_to root_path
  end

  def create
    flash[:alert] = @@no_registrations_message
    redirect_to root_path
  end
end