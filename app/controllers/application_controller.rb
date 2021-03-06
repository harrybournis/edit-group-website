class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  # customize the redirect path after a successfull sign in
  def after_sign_in_path_for(resource)
    root_path
  end

  protected

  def configure_permitted_parameters
    # Only add some parameters
    devise_parameter_sanitizer.for(:invite).concat [:isAdmin, :isStudent,  :member_from, :member_to, :invited_by_type,person_attributes:[:firstName,:lastName]]

    devise_parameter_sanitizer.for(:accept_invitation).concat [:crop_x, :crop_y, :crop_w, :crop_h, :bio, :avatar, :email, :password, :password_confirmation, :participant_id, :person_id,
                                                               participant_attributes:[:id,:title,:administrative_title,:email],
                                                               person_attributes: [:id,:firstName, :lastName],
                                                               personal_websites_attributes: [ :id, :url, :website_template_id, :_destroy]]
  end

end
