# frozen_string_literal: true

class AlbumsController < PublicController
  def all
    @albums = Album.includes(:event).order('events.date DESC').all
  end
end
