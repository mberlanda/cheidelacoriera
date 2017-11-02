# frozen_string_literal: true

class TransportMeanDecorator < ApplicationDecorator
  def datatable_index
    [
      link_to(object.kind, transport_mean_url(object.id)),
      object.company,
      object.email,
      object.phone_number,
      object.description
    ]
  end
end
