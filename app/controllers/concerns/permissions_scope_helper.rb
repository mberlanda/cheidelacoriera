# frozen_string_literal: true

module PermissionsScopeHelper
  extend ActiveSupport::Concern

  private

  def admin_user?
    return true if current_user&.admin?

    flash[:danger] = I18n.t('controllers.permissions.denied')
    session[:return_to] = request.referer || root_path
    redirect_to session[:return_to]
    false
  end

  def active_user?
    return true if current_user&.active?

    flash[:warning] = I18n.t('controllers.permissions.pending')
    session[:return_to] = request.referer || root_path
    redirect_to session[:return_to]
    false
  end
end
