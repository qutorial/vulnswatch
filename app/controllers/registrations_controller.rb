class RegistrationsController < Devise::RegistrationsController
  @@no_registrations_message = 'Registration is not available at the moment'
  def new
    flash[:warning] = @@no_registrations_message
    redirect_to root_path
  end

  def create
    flash[:warning] = @@no_registrations_message
    redirect_to root_path
  end
end
