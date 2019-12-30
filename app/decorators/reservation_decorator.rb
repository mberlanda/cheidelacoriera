# frozen_string_literal: true

class ReservationDecorator < ApplicationDecorator
  def datatable_reservations
    [
      link_to(status_field(object), reservation_url(object.id)),
      number_with_delimiter(object.total_seats),
      object.user.to_s,
      object.fan_names,
      object.phone_number,
      object.notes,
      object.stop
    ]
  end

  def datatable_index
    [
      link_to(object.event.to_s, reservation_url(object.id)),
      object.user_email,
      object.total_seats,
      status_field(object),
      object.fan_names,
      object.phone_number,
      object.mail_sent,
      object.notes,
      object.stop
    ]
  end
end
