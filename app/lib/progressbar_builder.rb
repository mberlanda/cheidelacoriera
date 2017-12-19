# frozen_string_literal: true

class ProgressbarBuilder
  include ActionView::Context
  include ActionView::Helpers::TagHelper

  # attr_accessor :output_buffer

  def self.build(event)
    new(event).item
  end

  def initialize(event)
    @event = event
    availability
  end

  def item
    # rubocop:disable Rails/OutputSafety
    content_tag :div, class: 'progress event-progress' do
      content_tag(:div, sr_only, bar_attributes)
    end.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def bar_attributes
    {
      class: "progress-bar #{bar_class}",
      role: :progressbar,
      'aria-valuenow' => 0,
      'aria-valuemin' => 0,
      'aria-valuemax' => 100,
      style: "width: #{availability}%;"
    }
  end

  def sr_only
    content_tag(:span, "#{availability}%", class: 'sr-only')
  end

  def availability
    @availability ||= @event.percentage_availability
  end

  def bar_class
    return 'progress-bar-danger' if availability <= 25
    return 'progress-bar-warning' if availability <= 50
    return 'progress-bar-info' if availability <= 75
    'progress-bar-success'
  end
end
