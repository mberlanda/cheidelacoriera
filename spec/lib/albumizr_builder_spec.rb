# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlbumizrBuilder do
  let(:album) { FactoryBot.build :album }

  it 'builds a photogallery_item' do
    actual = AlbumizrBuilder.build(album)
    expect(actual).to be_a_valid_html
  end

  it 'build_albumizr_button' do
    builder = AlbumizrBuilder.new(album)
    expect(builder.send(:build_albumizr_button)).to be_a_valid_html
  end
end
