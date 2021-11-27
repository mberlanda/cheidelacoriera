# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  let!(:team) { FactoryBot.create :team }

  context 'default team' do
    subject { team }

    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:country) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:image_url) }
    it { is_expected.to respond_to(:description) }
  end

  context 'events relationship' do
    let!(:home_event) { FactoryBot.create(:event, home_team: team) }
    let!(:away_event) { FactoryBot.create(:event, away_team: team) }

    it 'home_events' do
      expect(team.home_events).to eq([home_event])
    end

    it 'away_events' do
      expect(team.away_events).to eq([away_event])
    end

    it 'all events' do
      expect(team.events).to match_array([away_event, home_event])
    end
  end

  describe 'validates' do
    it 'name presence' do
      invalid_team = FactoryBot.build(:team, name: nil)
      expect(invalid_team.valid?).to be(false)
    end

    it 'name not empty' do
      invalid_team = FactoryBot.build(:team, name: '')
      expect(invalid_team.valid?).to be(false)
    end

    it 'country presence' do
      invalid_team = FactoryBot.build(:team, country: nil)
      expect(invalid_team.valid?).to be(false)
    end

    it 'country not empty' do
      invalid_team = FactoryBot.build(:team, country: '')
      expect(invalid_team.valid?).to be(false)
    end

    it 'name and country uniqueness' do
      invalid_team = FactoryBot.build(
        :team,
        name: team.name,
        country: team.country
      )
      expect(invalid_team.valid?).to be(false)
    end

    it 'nil url allowed' do
      valid_team = FactoryBot.build(:team, url: nil)
      expect(valid_team.valid?).to be(true)
    end

    it 'http url allowed' do
      valid_team = FactoryBot.build(:team, url: 'http://www.google.com')
      expect(valid_team.valid?).to be(true)
    end

    it 'https url allowed' do
      valid_team = FactoryBot.build(:team, url: 'https://www.google.com')
      expect(valid_team.valid?).to be(true)
    end

    it 'invalid url' do
      invalid_team = FactoryBot.build(:team, url: 'www.google.com')
      expect(invalid_team.valid?).to be(false)
    end
  end
end
