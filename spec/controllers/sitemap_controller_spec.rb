# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SitemapController, type: :controller do
  it 'return the expected sitemap without authentication' do
    FactoryBot.create(:event)

    get :index, format: :xml

    expect(response).to have_http_status(:ok)
  end
end
