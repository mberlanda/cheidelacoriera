# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumDecorator do
  it 'decorates without errors' do
    album = FactoryBot.create(:album)
    decorator = AlbumDecorator.new(album)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/albums/#{album.id}\">#{album.title}</a>",
        album.url,
        album.event.to_s
      ]
    )
  end
end
