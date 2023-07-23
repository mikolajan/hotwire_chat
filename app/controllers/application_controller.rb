class ApplicationController < ActionController::Base
  before_action :authenticate_user!, only: %i[create new show]
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    attributes = [:nickname]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  private

  def after_sign_in_path_for(resource)
    root_path
  end
end
