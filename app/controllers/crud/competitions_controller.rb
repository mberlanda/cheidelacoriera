# frozen_string_literal: true

class Crud::CompetitionsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[name]
  self.search_columns = %i[name]

  include DatatableController

  def datatable_columns
    %i[name created_at updated_at]
  end
end
