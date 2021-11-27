# frozen_string_literal: true

class Breadcrumb
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include SeoHelper

  def initialize(text, link = nil)
    @text = text
    @link = link
  end

  def to_li
    # rubocop:disable Rails/OutputSafety
    return tag.li(@text, class: :active).html_safe unless @link

    tag.li do
      tag.a(@text, href: seo_url(@link))
    end
    # rubocop:enable Rails/OutputSafety
  end
end

class BreadcrumbBuilder
  include ActionView::Context
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::UrlHelper
  delegate :url_helpers, to: 'Rails.application.routes'

  def self.build(*options)
    new(options).item
  end

  def initialize(options)
    *@links, @active = options
  end

  def item
    # rubocop:disable Rails/OutputSafety
    tag.ul(class: 'breadcrumb') do
      raw(@links.map { |l| Breadcrumb.new(*link_element(l)).to_li }.join) +
        Breadcrumb.new(active_element).to_li
    end.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  def active_element
    routes[@active] ? routes[@active].first : @active
  end

  def link_element(l)
    return l if l.is_a?(Array)

    routes[l] || [l]
  end

  def routes
    {
      home: ['Home', url_helpers.root_path],
      upcoming_events: [I18n.t('navbar.events.upcoming'), url_helpers.upcoming_events_path],
      all_events: [I18n.t('navbar.events.index'), url_helpers.all_events_path],
      news: [I18n.t('navbar.news.index'), url_helpers.news_index_path],
      posts: [I18n.t('navbar.posts.index'), url_helpers.all_posts_path],
      albums: [I18n.t('navbar.albums.index'), url_helpers.all_albums_path]
    }
  end
end
