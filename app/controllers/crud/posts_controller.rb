# frozen_string_literal: true

class Crud::PostsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[title image_url content date]
  self.search_columns = %i[title image_url content date]

  include DatatableController

  def datatable_columns
    %i[title image_url content date]
  end
end
