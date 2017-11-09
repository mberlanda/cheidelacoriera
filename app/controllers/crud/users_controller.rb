# frozen_string_literal: true

class Crud::UsersController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[email password password_confirmation status role]
  self.search_columns = %i[email status role]
  include Crud::UsersHelper
  include DatatableController

  def datatable_columns
    @datatable_columns ||= %i[email status role]
  end

  def index; end

  def approve_all
    pending_users = User.where(status: :pending)
    pending_users.update(status: :active)

    pending_users.each { |u| UserMailer.activation_email(u).deliver }
    flash[:success] = I18n.t('controllers.users.approve_all.flash')
    flash.keep
    redirect_to action: :index
  end

  def update
    @user = User.find(params.require(:id))
    user_params = params.require(:user).permit(*permitted_attrs)

    @user.update(filter_password_params(user_params))

    if @user.valid?
      flash[:success] = "#{@user.email} successfully updated"
      render action: :show
    else
      render action: :edit
    end
  end
end
