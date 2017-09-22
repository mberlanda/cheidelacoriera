# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:competition) { FactoryGirl.create :competition }
  let!(:team1) { FactoryGirl.create :team }
  let!(:team2) { FactoryGirl.create :team }

  context 'default event' do
    subject do
      FactoryGirl.create(
        :event,
        competition: competition,
        home_team: team1,
        away_team: team2
      )
    end

    it { should respond_to(:date) }
    it { should respond_to(:time) }
    it { should respond_to(:season) }
    it { should respond_to(:score) }
    it { should respond_to(:notes) }
    it { should respond_to(:home_team) }
    it { should respond_to(:away_team) }
    it { should respond_to(:competition) }

    it 'belongs to a competition' do
      expect(subject.competition).to eq(competition)
    end

    it 'belongs to a team' do
      event1 = FactoryGirl.create(:event, home_team: team1)
      event2 = FactoryGirl.create(:event, home_team: team1)
      event3 = FactoryGirl.create(:event, away_team: team1)

      expect(team1.home_events).to match_array([event1, event2])
      expect(team1.away_events).to match_array([event3])
      expect(team1.events).to match_array([event1, event2, event3])
    end
  end
end
