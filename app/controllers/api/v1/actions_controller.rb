# frozen_string_literal: true

class Api::V1::ActionsController < ApplicationController
  skip_before_action :authenticate_user!

  def available
    default = current_user ? {} : { login: new_user_session_path }
    @actions = default.merge(
      upcoming_events: upcoming_events_path,
      news: news_index_path,
      posts: all_posts_path,
      photogallery: all_albums_path,
      regolamento: regolamento_path
    )
  end
end
