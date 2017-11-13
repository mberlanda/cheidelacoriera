# frozen_string_literal: true

class Crud::AlbumsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[title url event_id]
  self.search_columns = %i[title url event_id]

  include DatatableController

  def datatable_columns
    %i[title url event_id]
  end
end
