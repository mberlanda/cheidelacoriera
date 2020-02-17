# frozen_string_literal: true

class Crud::UsersController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[
    email password password_confirmation status role
    first_name last_name phone_number date_of_birth
    place_of_birth
  ]
  self.search_columns = %i[email status role]
  include Crud::UsersHelper
  include DatatableController

  def datatable_columns
    @datatable_columns ||= %i[
      email first_name last_name status role phone_number
      newsletter mailing_listed activation_date
    ]
  end

  def index; end

  def approve_all
    pending_users = User.where(status: :pending)
    pending_users.update(status: :active)

    User.actives.to_notify.each { |u| UserMailer.activation_email(u).deliver_later }
    flash[:success] = I18n.t('controllers.users.approve_all.flash')
    flash.keep
    redirect_to action: :index
  end

  def mailing_list
    users_to_add = User.actives.where(newsletter: true, mailing_listed: false)
    MailchimpJob.perform_later(*users_to_add)

    flash[:success] = I18n.t('controllers.users.mailing_list.flash')
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

  def model_datatable_index(model_result)
    decorator = DecoratorHelper.new
    # Another level of optimitation could be to remove the following
    # line and replace with a scoped query only on the used columns
    @response = model_result

    @data = @response.map { |r| decorator.users(r) }

    render_datatable_response
  end
end
