# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventDecorator do
  it 'decorates without errors' do
    event = FactoryBot.create(:event)
    decorator = described_class.new(event)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/events/#{event.id}\">#{event.date}</a>",
        event.season,
        event.audience,
        event.pax,
        event.bookable_from,
        event.bookable_until,
        event.home_team.to_s,
        event.away_team.to_s,
        event.transport_mean,
        event.total_seats,
        event.available_seats,
        event.competition.to_s,
        event.venue,
        event.poster_url,
        event.stops
      ]
    )
  end
end
