# frozen_string_literal: true

class EventDecorator < Drape::Decorator
  include Drape::LazyHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  delegate_all

  def datatable_index
    [
      link_to(object.date, event_url(object.id)),
      object.season,
      object.home_team.to_s,
      object.away_team.to_s,
      object.competition.to_s,
      object.venue,
      object.poster_url
    ]
  end
end
