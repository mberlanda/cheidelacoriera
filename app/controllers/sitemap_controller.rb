# frozen_string_literal: true

class SitemapController < PublicController
  layout false

  def index
    @pages ||= prepare_pages
    @items ||= prepare_items

    respond_to do |format|
      format.xml
    end
  end

  private

  def prepare_pages
    [
      upcoming_events_url, news_index_url, all_albums_url,
      all_posts_url, new_user_session_url
    ]
  end

  def prepare_items
    Event.all.map do |e|
      details_event_url(e.slug)
    end
  end
end
