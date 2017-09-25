# frozen_string_literal: true

class Crud::UsersController < CrudController
  before_action :authenticate_user!

  self.permitted_attrs = %i[email password password_confirmation status role]
end
