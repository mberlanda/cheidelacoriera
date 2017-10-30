# frozen_string_literal: true

class Crud::TripsController < CrudController
  before_action :authenticate_user!
  before_action :admin_user?

  self.permitted_attrs = %i[
    total_seats available_seats reserved_seats requested_seats
    event_id transport_mean_id bookable_from bookable_until
    name
  ]
  self.search_columns = %i[
    total_seats available_seats reserved_seats requested_seats
    event_id transport_mean_id bookable_from bookable_until
    name
  ]
end
