# frozen_string_literal: true

class EventDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.date, event_url(object.id)),
      object.season,
      object.bookable_from,
      object.bookable_until,
      object.home_team.to_s,
      object.away_team.to_s,
      object.competition.to_s,
      object.venue,
      object.poster_url
    ]
  end
end
