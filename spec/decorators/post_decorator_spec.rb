# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostDecorator do
  it 'decorates without errors' do
    post = FactoryBot.create(:post)
    decorator = PostDecorator.new(post)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/posts/#{post.id}\">#{post.title}</a>",
        post.image_url,
        post.content.truncate(15),
        post.date
      ]
    )
  end
end
