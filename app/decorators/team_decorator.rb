# frozen_string_literal: true

class TeamDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.name, team_url(object.id)),
      object.country,
      object.url,
      object.image_url,
      object.description
    ]
  end
end
