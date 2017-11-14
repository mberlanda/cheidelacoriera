# frozen_string_literal: true

class AlbumDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.title, album_url(object.id)),
      object.url,
      object.event.to_s
    ]
  end
end
