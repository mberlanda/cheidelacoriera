# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::EventsController', type: :request do
  describe '#index' do
    context 'when no session' do
      it 'returns empty array if no events' do
        get '/api/events.json'

        expect(response.body).to eq('[]')
      end

      it 'returns one event avoiding unnecessary eager loading' do
        event = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(1)
          expect(json_response.map { |h| h['id'] }).to match_array([event.id])
        end
      end

      it 'returns multiple events avoiding unnecessary eager loading' do
        event1 = FactoryBot.create(:event)
        event2 = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(2)
          expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
        end
      end
    end

    context 'when fan logged-in' do
      let(:fan) { FactoryBot.create(:user, role: :fan, status: :active) }

      before { sign_in fan }

      it 'returns empty array if no events' do
        get '/api/events.json'

        expect(response.body).to eq('[]')
      end

      it 'returns one event preventing n+1' do
        event = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(1)
          expect(json_response.map { |h| h['id'] }).to match_array([event.id])
        end
      end

      it 'returns multiple events preventing n+1' do
        event1 = FactoryBot.create(:event)
        event2 = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(2)
          expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
        end
      end
    end

    context 'when admin logged-in' do
      let(:admin) { FactoryBot.create(:user, role: :admin, status: :active) }

      before { sign_in admin }

      it 'returns empty array if no events' do
        get '/api/events.json'

        expect(response.body).to eq('[]')
      end

      it 'returns one event preventing n+1' do
        event = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(1)
          expect(json_response.map { |h| h['id'] }).to match_array([event.id])
        end
      end

      it 'returns multiple events preventing n+1' do
        event1 = FactoryBot.create(:event)
        event2 = FactoryBot.create(:event)

        get '/api/events.json'

        json_response = JSON.parse(response.body)

        aggregate_failures do
          expect(json_response.size).to eq(2)
          expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
        end
      end
    end
  end

  describe '#upcoming' do
    it 'displays only upcoming events' do
      past_event = FactoryBot.create(:event)
      future_event1 = FactoryBot.create(:event, date: Date.new(2099, 9, 20))
      future_event2 = FactoryBot.create(:event, date: Date.new(2099, 9, 20))

      get '/api/events/upcoming.json'

      event_ids = JSON.parse(response.body).map { |h| h['id'] }
      aggregate_failures do
        expect(event_ids).to include(future_event1.id, future_event2.id)
        expect(event_ids).not_to include(past_event.id)
      end
    end
  end
end
