# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransportMeanDecorator do
  it 'decorates without errors' do
    transport_mean = FactoryBot.create(:transport_mean)
    decorator = described_class.new(transport_mean)

    expect(decorator.datatable_index).to eq(
      [
        "<a href=\"http://test.host/admin/transport_means/#{transport_mean.id}\">#{transport_mean.kind}</a>",
        transport_mean.company,
        transport_mean.email,
        transport_mean.phone_number,
        transport_mean.description
      ]
    )
  end
end
