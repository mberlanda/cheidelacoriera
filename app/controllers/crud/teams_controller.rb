# frozen_string_literal: true

class Crud::TeamsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[name country url image_url description]
  self.search_columns = %i[name country url image_url description]

  include DatatableController

  def datatable_columns
    %i[name country url image_url description]
  end
end
