# frozen_string_literal: true

class PostDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.title, post_url(object.id)),
      object.image_url,
      strip_tags(object.content || '').truncate(15),
      object.date
    ]
  end
end
