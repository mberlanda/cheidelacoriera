# frozen_string_literal: true

class TripDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.name || 'n/a', trip_url(object.id)),
      object.bookable_from,
      object.bookable_until,
      object.total_seats,
      object.available_seats,
      object.reserved_seats,
      object.requested_seats,
      object.event.to_s,
      object.transport_mean.to_s
    ]
  end
end
