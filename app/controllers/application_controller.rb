# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  # before_action :set_locale
  include PermissionsScopeHelper

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :disable_subtitle, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  def raise_not_found
    raise ActionController::RoutingError,
          "No route matches #{params[:unmatched_route]}"
  end

  def not_found
    flash[:danger] = 'Non ho trovato la pagina che stai cercando'
    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

  def error
    flash[:danger] = 'Attenzione. Si è verificato un errore'
    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml { head :not_found }
      format.any { head :not_found }
    end
  end

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
