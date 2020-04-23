# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include PostsHelper
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?
 

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
  end

  private

  def current_room
    @room ||= Room.find(session[:current_room]) if session[:current_room]
  end


  helper_method :current_room

end
