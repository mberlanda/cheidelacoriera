# frozen_string_literal: true

class Crud::TripsController < CrudController
  before_action :authenticate_user!
  self.permitted_attrs = %i[
    total_seats available_seats reserved_seats requested_seats
    event_id transport_mean_id
  ]
  self.search_columns = %i[
    total_seats available_seats reserved_seats requested_seats
    event_id transport_mean_id
  ]
end
