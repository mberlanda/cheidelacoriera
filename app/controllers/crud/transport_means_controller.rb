# frozen_string_literal: true

class Crud::TransportMeansController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[kind company email phone_number description]
  self.search_columns = %i[kind company email phone_number description]

  include DatatableController

  def datatable_columns
    %i[kind company email phone_number description]
  end
end
