# frozen_string_literal: true

class CompetitionDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.name, competition_url(object.id)),
      object.created_at.to_date.to_s,
      object.updated_at.to_date.to_s
    ]
  end
end
