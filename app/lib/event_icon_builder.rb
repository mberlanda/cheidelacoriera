# frozen_string_literal: true

class EventIconBuilder
  include ActionView::Context
  include ActionView::Helpers::TagHelper

  def self.build(icon_type)
    new(icon_type).item
  end

  def initialize(icon_type)
    @icon_type = icon_type
  end

  def item
    # rubocop:disable Rails/OutputSafety
    content_tag(:i, sr_only, icon_attributes).html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def sr_only
    content_tag(:span, message[@icon_type], class: 'sr-only')
  end

  def icon_attributes
    {
      class: classes[@icon_type],
      'aria-hidden' => true,
      'data-toggle' => 'tooltip',
      title: message[@icon_type]
    }
  end

  def message
    {
      available: 'Prenotabile',
      fully_booked: 'Disponibilità Esaurita',
      preferred: 'Solo Corieristi Semper Fidelis'
    }
  end

  def classes
    {
      available: 'fa fa-calendar-check-o icon-green ',
      fully_booked: 'fa fa-calendar-times-o icon-red',
      preferred: 'fa fa-star icon-yellow'
    }
  end
end
