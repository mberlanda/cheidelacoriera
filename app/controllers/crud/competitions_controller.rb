# frozen_string_literal: true

class Crud::CompetitionsController < CrudController
  before_action :authenticate_user!
  self.permitted_attrs = %i[name]
  self.search_columns = %i[name]
end
