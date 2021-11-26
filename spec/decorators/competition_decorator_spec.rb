# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompetitionDecorator do
  it 'decorates without errors' do
    competition = FactoryBot.create(:competition)
    decorator = CompetitionDecorator.new(competition)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/competitions/#{competition.id}\">#{competition.name}</a>",
        competition.created_at.to_date.to_s,
        competition.updated_at.to_date.to_s
      ]
    )
  end
end
