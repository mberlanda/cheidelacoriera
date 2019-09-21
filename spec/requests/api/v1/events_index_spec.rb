# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::EventsController#index', type: :request do
  context 'when no session' do
    it 'returns empty array if no events' do
      get '/api/events.json'

      expect(response.body).to eq('[]')
    end

    it 'returns one event avoiding unnecessary eager loading' do
      event = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(1)
        expect(json_response.map { |h| h['id'] }).to match_array([event.id])
      end
    end

    it 'returns multiple events avoiding unnecessary eager loading' do
      event1 = FactoryGirl.create(:event)
      event2 = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(2)
        expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
      end
    end
  end

  context 'when fan logged-in' do
    let(:fan) { FactoryGirl.create(:user, role: :fan, status: :active) }

    before(:each) { sign_in fan }

    it 'returns empty array if no events' do
      get '/api/events.json'

      expect(response.body).to eq('[]')
    end

    it 'returns one event preventing n+1' do
      event = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(1)
        expect(json_response.map { |h| h['id'] }).to match_array([event.id])
      end
    end

    it 'returns multiple events preventing n+1' do
      event1 = FactoryGirl.create(:event)
      event2 = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(2)
        expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
      end
    end
  end

  context 'when admin logged-in' do
    let(:admin) { FactoryGirl.create(:user, role: :admin, status: :active) }

    before(:each) { sign_in admin }

    it 'returns empty array if no events' do
      get '/api/events.json'

      expect(response.body).to eq('[]')
    end

    it 'returns one event preventing n+1' do
      event = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(1)
        expect(json_response.map { |h| h['id'] }).to match_array([event.id])
      end
    end

    it 'returns multiple events preventing n+1' do
      event1 = FactoryGirl.create(:event)
      event2 = FactoryGirl.create(:event)

      get '/api/events.json'

      json_response = JSON.parse(response.body)

      aggregate_failures do
        expect(json_response.size).to eq(2)
        expect(json_response.map { |h| h['id'] }).to match_array([event1.id, event2.id])
      end
    end
  end
end
