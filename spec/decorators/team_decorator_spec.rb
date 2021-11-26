# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamDecorator do
  it 'decorates without errors' do
    team = FactoryBot.create(:team)
    decorator = TeamDecorator.new(team)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/teams/#{team.id}\">#{team.name}</a>",
        team.country,
        team.url,
        team.image_url,
        team.description
      ]
    )
  end
end
