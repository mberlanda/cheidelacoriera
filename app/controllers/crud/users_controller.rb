class Crud::UsersController < CrudController
  self.permitted_attrs = [:email, :password, :password_confirmation, :status, :role]
end
