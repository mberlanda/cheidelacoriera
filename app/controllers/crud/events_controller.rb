# frozen_string_literal: true

class Crud::EventsController < CrudController
  before_action :authenticate_user!
  self.permitted_attrs = %i[date time season score notes home_team_id
                            away_team_id competition_id]
  self.search_columns = %i[date season home_team_id away_team_id competition_id]
end
