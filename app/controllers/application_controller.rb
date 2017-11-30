# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # before_action :set_locale
  include PermissionsScopeHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :disable_subtitle, if: :devise_controller?

  protected

  def configure_permitted_parameters
    permitted = %i[
      first_name last_name profile_name email password
      date_of_birth place_of_birth newsletter phone_number
    ]
    devise_parameter_sanitizer.permit(:sign_up, keys: permitted)
    devise_parameter_sanitizer.permit(:account_update, keys: permitted)
  end

  private

  def disable_subtitle
    @disable_subtitle = true
  end

  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  #   Rails.application.routes.default_url_options[:locale] = I18n.locale
  # end
end
