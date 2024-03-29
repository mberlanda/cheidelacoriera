# frozen_string_literal: true

class AlbumizrBuilder
  include ActionView::Context
  include ActionView::Helpers::TagHelper

  # attr_accessor :output_buffer

  def self.build(album)
    new(album).photogallery_item
  end

  def initialize(album)
    @album = album
  end

  def photogallery_item
    # rubocop:disable Rails/OutputSafety
    tag.div(class: 'photogallery-item') do
      tag.p(@album.title) +
        tag.div(build_albumizr_iframe(@album.url), class: 'embed-responsive-item') +
        # content_tag(:div, build_albumizr_button, class: 'text-center')
        tag.div(build_albumizr_link, class: 'text-center')
    end.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def build_albumizr_iframe(url)
    tag.iframe(nil, class: 'iframe-fullscreen', allowfullscreen: '', height: '300px',
                    scrolling: 'no', src: url, width: '100%')
  end

  def build_albumizr_link
    tag.a(class: 'btn btn-primary fullscreen-btn',
          href: @album.url, target: '_blank') do
      "#{tag.i(nil, class: 'glyphicon glyphicon-fullscreen')} FullScreen"
    end
  end

  def build_albumizr_button
    tag.button(class: 'btn btn-primary fullscreen-btn', role: :button) do
      "#{tag.i(nil, class: 'glyphicon glyphicon-fullscreen')} FullScreen"
    end
  end
end
