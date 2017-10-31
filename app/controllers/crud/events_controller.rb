# frozen_string_literal: true

class Crud::EventsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[date time season score notes home_team_id
                            away_team_id competition_id venue poster_url]
  self.search_columns = %i[date season home_team_id away_team_id competition_id
                           venue poster_url]

  def datatable_index
    @response = Event.all
    @data = @response.map { |e| EventDecorator.new(e).datatable_index }
    render_datatable_response
  end

  private

  def render_datatable_response
    respond_to do |format|
      format.json { render 'shared/search' }
    end
  end
end
