# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    default = current_user ? {} : { login: new_user_session_path }
    @actions = default.merge(
      upcoming_events: upcoming_events_path,
      news: news_index_path,
      photogallery: all_albums_path,
      regolamento: regolamento_path

    )
  end

  def regolamento; end
end
