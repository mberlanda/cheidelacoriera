# frozen_string_literal: true

class AlbumsController < PublicController
  def all
    @albums = Album.all
  end
end
