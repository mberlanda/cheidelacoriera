# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:competition) { FactoryGirl.create :competition }
  let!(:team1) { FactoryGirl.create :team }
  let!(:team2) { FactoryGirl.create :team }

  context 'default event' do
    subject do
      FactoryGirl.build(
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
    it { should respond_to(:venue) }
    it { should respond_to(:poster_url) }
    it { should respond_to(:requested_seats) }
    it { should respond_to(:confirmed_seats) }
    it { should respond_to(:bookable_from) }
    it { should respond_to(:bookable_until) }
    it { should respond_to(:rejected_seats) }
    it { should respond_to(:pax) }
    it { should respond_to(:audience) }
    it { should respond_to(:transport_mean) }

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

  context '.upcoming' do
    before do
      default_date = Date.new(2017, 10, 1)
      allow(Date).to receive(:today).and_return(default_date)
      @past_event = FactoryGirl.create(:event, date: default_date - 1.day)
      @same_day_event = FactoryGirl.create(:event, date: default_date)
      @future_event = FactoryGirl.create(:event, date: default_date + 1.day)
    end

    it 'should mock date today' do
      expect(Date.today).to eq(Date.new(2017, 10, 1))
    end

    it 'should filter past events' do
      expect(Event.upcoming).to match_array([@same_day_event, @future_event])
    end
  end

  context '.bookable' do
    before do
      DatabaseCleaner.clean_with(:truncation)
      @event1 = FactoryGirl.create(
        :event,
        bookable_from: Date.today,
        bookable_until: Date.today + 5.days
      )
      @event2 = FactoryGirl.create(
        :event,
        bookable_from: Date.today - 5.days,
        bookable_until: Date.today + 1.day
      )
    end

    it 'uses by default Date.today' do
      actual = Event.bookable
      expect(actual.count).to eq(2)
      expect(actual).to match_array([@event1, @event2])
    end

    it 'can use custom date' do
      actual = Event.bookable(Date.today - 2.days)
      expect(actual.count).to eq(1)
      expect(actual).to match_array([@event2])
    end
  end

  context 'slug_name generation' do
    let(:event_date) { Date.new(2017, 1, 1) }
    subject do
      FactoryGirl.build(
        :event,
        competition: competition,
        date: event_date,
        home_team: team1,
        away_team: team2,
        transport_mean: nil
      )
    end

    it 'should not include transport mean if null' do
      expect(subject.send(:custom_slug_name)).to eq([
        subject.home_team.name.downcase.tr(' ', '-').to_s,
        subject.away_team.name.downcase.tr(' ', '-').to_s,
        subject.competition.name.downcase.tr(' ', '-').to_s,
        event_date.to_s
      ].join('-'))
    end

    it 'should include transport mean if present' do
      transport_mean = 'bus'
      subject.update(transport_mean: transport_mean)

      expect(subject.send(:custom_slug_name)).to eq([
        subject.home_team.name.downcase.tr(' ', '-').to_s,
        subject.away_team.name.downcase.tr(' ', '-').to_s,
        subject.competition.name.downcase.tr(' ', '-').to_s,
        event_date.to_s,
        transport_mean.to_s
      ].join('-'))
    end
  end
end
