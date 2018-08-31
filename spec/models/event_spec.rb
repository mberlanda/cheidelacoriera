# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:competition) { FactoryGirl.create :competition }
  let!(:team1) { FactoryGirl.create :team }
  let!(:team2) { FactoryGirl.create :team }

  it '#transport_mean_class method' do
    expect(Event.transport_mean_class('bus')).to eq('fa fa-bus')
    expect(Event.transport_mean_class('aereo')).to eq('fa fa-plane')
    expect(Event.transport_mean_class('invalid')).to eq(nil)
  end

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
      allow(Time.zone).to receive(:today).and_return(default_date)
      @past_event = FactoryGirl.create(:event, date: default_date - 1.day)
      @same_day_event = FactoryGirl.create(:event, date: default_date)
      @future_event = FactoryGirl.create(:event, date: default_date + 1.day)
    end

    it 'should mock date today' do
      expect(Time.zone.today).to eq(Date.new(2017, 10, 1))
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
        bookable_from: Time.zone.today,
        bookable_until: Time.zone.today + 5.days
      )
      @event2 = FactoryGirl.create(
        :event,
        bookable_from: Time.zone.today - 5.days,
        bookable_until: Time.zone.today + 1.day
      )
    end

    it 'uses by default Time.zone.today' do
      actual = Event.bookable
      expect(actual.count).to eq(2)
      expect(actual).to match_array([@event1, @event2])
    end

    it 'can use custom date' do
      actual = Event.bookable(Time.zone.today - 2.days)
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

  context '.handle_seats_changes before save' do
    let(:event_date) { Date.new(2017, 1, 1) }

    def decrease_availability_test(subject, attribute, amount)
      expect do
        subject.update! attribute => amount
      end.to change {
        subject.available_seats
      }.by amount * -1
    end

    subject do
      FactoryGirl.create(
        :event,
        competition: competition,
        date: event_date,
        home_team: team1,
        away_team: team2,
        transport_mean: nil,
        confirmed_seats: 0,
        requested_seats: 0,
        available_seats: 0,
        total_seats: 50
      )
    end

    it 'decrease availability if will_save_change_to_confirmed_seats?' do
      decrease_availability_test(subject, :confirmed_seats, 7)
    end

    it 'decrease availability if will_save_change_to_requested_seats?' do
      decrease_availability_test(subject, :requested_seats, 8)
    end

    it 'recalculate availability when total_seats changed and no reservations' do
      amount = 15
      subject.update! available_seats: 0
      expect { subject.update! total_seats: amount }.to change {
        subject.available_seats
      }.from(0).to(amount)
    end

    it 'recalculate availability when total_seats changed and 1+ reservations' do
      amount = 15
      fans = ['one fan', 'another fan']
      subject.update! available_seats: 0
      FactoryGirl.create(:reservation, event: subject, fan_names: fans)

      expect { subject.update! total_seats: amount }.to change {
        subject.available_seats
      }.from(fans.size * -1).to(amount - fans.size)
    end
  end

  context 'clean up params before validation' do
    subject do
      FactoryGirl.build(
        :event,
        competition: competition,
        home_team: team1,
        away_team: team2
      )
    end

    it 'should strip valid transport mean (bus|aereo)' do
      subject.update(transport_mean: '  bus  ')
      subject.save!

      expect(subject.transport_mean).to eq('bus')
    end

    it 'should nullify invalid transport means' do
      subject.update(transport_mean: '  invalid  ')
      subject.save!

      expect(subject.transport_mean).to eq(nil)
    end

    it 'should assign the custom_name as slug_name' do
      expect(subject.slug).to eq(subject.custom_name)
    end
  end
end
