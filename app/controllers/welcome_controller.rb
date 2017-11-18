# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  def index
    @actions = {
      upcoming_events: upcoming_events_path,
      news: news_index_path,
      photogallery: all_albums_path
    }
  end
end
