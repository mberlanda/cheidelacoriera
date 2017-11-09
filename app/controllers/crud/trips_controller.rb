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

  include DatatableController

  def datatable_columns
    %i[
      name bookable_from bookable_until total_seats available_seats
      reserved_seats requested_seats event_id transport_mean_id
    ]
  end

  def datatable_reservations
    trip_id = Trip.find(params[:id]).id
    @response = Reservation.includes(:user).where(trip_id: trip_id)
    @data = @response.map do |r|
      ReservationDecorator.new(r).datatable_reservations
    end
    respond_to do |format|
      format.json { render 'shared/search' }
    end
  end
end
