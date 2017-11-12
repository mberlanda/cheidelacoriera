# frozen_string_literal: true

class ReservationDecorator < ApplicationDecorator
  def datatable_reservations
    [
      link_to(object.status, reservation_url(object.id)),
      number_with_delimiter(object.total_seats),
      object.user.to_s,
      object.fan_names,
      object.phone_number,
      object.notes
    ]
  end

  def datatable_index
    [
      link_to(object.trip.to_s, reservation_url(object.id)),
      object.user.to_s,
      object.total_seats,
      object.status,
      object.fan_names,
      object.phone_number,
      object.notes
    ]
  end
end