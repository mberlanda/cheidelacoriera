# frozen_string_literal: true

module PermissionsScopeHelper
  extend ActiveSupport::Concern

  private

  def admin_user?
    return true if current_user.admin?
    flash[:danger] = I18n.t('controllers.permissions.denied')
    redirect_to root_path
    false
  end

  def active_user?
    return true if current_user.active?
    flash[:warning] = I18n.t('controllers.permissions.pending')
    redirect_to root_path
    false
  end
end
