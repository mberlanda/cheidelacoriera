# frozen_string_literal: true

class AlbumizrBuilder
  include ActionView::Context
  include ActionView::Helpers::TagHelper

  # attr_accessor :output_buffer

  def self.build(url)
    new(url).photogallery_item
  end

  def initialize(url)
    @url = url
  end

  def photogallery_item
    # rubocop:disable Rails/OutputSafety
    content_tag :div, class: 'photogallery-item' do
      content_tag(:div, build_albumizr_iframe(@url), class: 'embed-responsive-item') +
        content_tag(:div, build_albumizr_button, class: 'text-center')
    end.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def build_albumizr_iframe(url)
    content_tag(
      :iframe, nil, class: 'iframe-fullscreen', allowfullscreen: '', height: '100%',
                    scrolling: 'no', src: url, width: '100%'
    )
  end

  def build_albumizr_button
    content_tag(:button, class: 'btn btn-primary fullscreen-btn', role: :button) do
      content_tag(:i, nil, class: 'glyphicon glyphicon-fullscreen') +
        ' FullScreen'
    end
  end
end
