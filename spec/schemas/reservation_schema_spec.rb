# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReservationSchema do
  describe '.jsonschema' do
    context 'when stops are not provided' do
      it 'returns some default values discarding stops' do
        j = described_class.jsonschema(stops: [])

        aggregate_failures do
          expect(j.keys).to match_array(%i[title description type required properties])
          expect(j[:required]).to match_array(%w[phone_number fan_names])
          expect(j[:properties].keys).to match_array(
            %i[
              authenticity_token event_id user_id phone_number
              fans_count fan_names notes
            ]
          )
        end
      end
    end

    context 'when stops are provided' do
      it 'returns some default values adding stops' do
        j = described_class.jsonschema(stops: %w[Bergamo Foo Bar])

        aggregate_failures do
          expect(j.keys).to match_array(%i[title description type required properties])
          expect(j[:required]).to match_array(%w[phone_number fan_names stop])
          expect(j[:properties].keys).to match_array(
            %i[
              authenticity_token event_id user_id phone_number
              fans_count fan_names notes stop
            ]
          )
        end
      end
    end
  end
end
