# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.date, event_url(object.id)),
      object.season,
      object.audience,
      object.pax,
      object.bookable_from,
      object.bookable_until,
      object.home_team.to_s,
      object.away_team.to_s,
      object.transport_mean,
      object.total_seats,
      object.available_seats,
      object.competition.to_s,
      object.venue,
      object.poster_url,
      object.stops
    ]
  end
end
