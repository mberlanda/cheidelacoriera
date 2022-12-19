# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:competition) { FactoryBot.create :competition }
  let!(:team1) { FactoryBot.create :team }
  let!(:team2) { FactoryBot.create :team }

  it '#transport_mean_class method' do
    expect(described_class.transport_mean_class('bus')).to eq('fa fa-bus')
    expect(described_class.transport_mean_class('aereo')).to eq('fa fa-plane')
    expect(described_class.transport_mean_class('invalid')).to eq(nil)
  end

  context 'default event' do
    subject do
      FactoryBot.build(
        :event,
        competition:,
        home_team: team1,
        away_team: team2
      )
    end

    it { is_expected.to respond_to(:date) }
    it { is_expected.to respond_to(:time) }
    it { is_expected.to respond_to(:season) }
    it { is_expected.to respond_to(:score) }
    it { is_expected.to respond_to(:notes) }
    it { is_expected.to respond_to(:home_team) }
    it { is_expected.to respond_to(:away_team) }
    it { is_expected.to respond_to(:competition) }
    it { is_expected.to respond_to(:venue) }
    it { is_expected.to respond_to(:poster_url) }
    it { is_expected.to respond_to(:requested_seats) }
    it { is_expected.to respond_to(:confirmed_seats) }
    it { is_expected.to respond_to(:bookable_from) }
    it { is_expected.to respond_to(:bookable_until) }
    it { is_expected.to respond_to(:rejected_seats) }
    it { is_expected.to respond_to(:pax) }
    it { is_expected.to respond_to(:audience) }
    it { is_expected.to respond_to(:transport_mean) }
    it { is_expected.to respond_to(:stops) }
    it { is_expected.to respond_to(:available_stops) }

    it 'belongs to a competition' do
      expect(subject.competition).to eq(competition)
    end

    it 'belongs to a team' do
      event1 = FactoryBot.create(:event, home_team: team1)
      event2 = FactoryBot.create(:event, home_team: team1)
      event3 = FactoryBot.create(:event, away_team: team1)

      expect(team1.home_events).to match_array([event1, event2])
      expect(team1.away_events).to match_array([event3])
      expect(team1.events).to match_array([event1, event2, event3])
    end
  end

  describe '.upcoming' do
    before do
      default_date = Date.new(2017, 10, 1)
      allow(Time.zone).to receive(:today).and_return(default_date)
      @past_event = FactoryBot.create(:event, date: default_date - 1.day)
      @same_day_event = FactoryBot.create(:event, date: default_date)
      @future_event = FactoryBot.create(:event, date: default_date + 1.day)
    end

    it 'mocks date today' do
      expect(Time.zone.today).to eq(Date.new(2017, 10, 1))
    end

    it 'filters past events' do
      expect(described_class.upcoming).to match_array([@same_day_event, @future_event])
    end
  end

  describe '.bookable' do
    before do
      DatabaseCleaner.clean_with(:truncation)
      @event1 = FactoryBot.create(
        :event,
        bookable_from: Time.zone.today,
        bookable_until: Time.zone.today + 5.days
      )
      @event2 = FactoryBot.create(
        :event,
        bookable_from: Time.zone.today - 5.days,
        bookable_until: Time.zone.today + 1.day
      )
    end

    it 'uses by default Time.zone.today' do
      actual = described_class.bookable
      expect(actual.count).to eq(2)
      expect(actual).to match_array([@event1, @event2])
    end

    it 'can use custom date' do
      actual = described_class.bookable(Time.zone.today - 2.days)
      expect(actual.count).to eq(1)
      expect(actual).to match_array([@event2])
    end
  end

  context 'slug_name generation' do
    subject do
      FactoryBot.build(
        :event,
        competition:,
        date: event_date,
        home_team: team1,
        away_team: team2,
        transport_mean: nil
      )
    end

    let(:event_date) { Date.new(2017, 1, 1) }

    it 'does not include transport mean if null' do
      expect(subject.send(:custom_slug_name)).to eq([
        subject.home_team.name.downcase.tr(' ', '-').to_s,
        subject.away_team.name.downcase.tr(' ', '-').to_s,
        subject.competition.name.downcase.tr(' ', '-').to_s,
        event_date.to_s
      ].join('-'))
    end

    it 'includes transport mean if present' do
      transport_mean = 'bus'
      subject.update(transport_mean:)

      expect(subject.send(:custom_slug_name)).to eq([
        subject.home_team.name.downcase.tr(' ', '-').to_s,
        subject.away_team.name.downcase.tr(' ', '-').to_s,
        subject.competition.name.downcase.tr(' ', '-').to_s,
        event_date.to_s,
        transport_mean.to_s
      ].join('-'))
    end
  end

  describe '.handle_seats_changes before save' do
    subject do
      FactoryBot.create(
        :event,
        competition:,
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

    let(:event_date) { Date.new(2017, 1, 1) }

    def decrease_availability_test(subject, attribute, amount)
      expect do
        subject.update! attribute => amount
      end.to change {
        subject.available_seats
      }.by amount * -1
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
      expect do
        subject.update! total_seats: amount
      end.to change(subject,
                    :available_seats).from(0).to(amount)
    end

    it 'recalculate availability when total_seats changed and 1+ reservations' do
      amount = 15
      fans = ['one fan', 'another fan']
      subject.update! available_seats: 0
      FactoryBot.create(:reservation, event: subject, fan_names: fans)

      expect do
        subject.update! total_seats: amount
      end.to change(subject,
                    :available_seats).from(fans.size * -1).to(amount - fans.size)
    end
  end

  context 'clean up params before validation' do
    subject do
      FactoryBot.build(
        :event,
        competition:,
        home_team: team1,
        away_team: team2
      )
    end

    it 'strips valid transport mean (bus|aereo)' do
      subject.update(transport_mean: '  bus  ')
      subject.save!

      expect(subject.transport_mean).to eq('bus')
    end

    it 'nullifies invalid transport means' do
      subject.update(transport_mean: '  invalid  ')
      subject.save!

      expect(subject.transport_mean).to eq(nil)
    end

    it 'assigns the custom_name as slug_name' do
      expect(subject.slug).to eq(subject.custom_name)
    end
  end

  describe '.available_stops' do
    let(:event) { FactoryBot.build(:event) }

    it 'handles null stops' do
      aggregate_failures do
        expect(event.stops).to be_nil
        expect(event.available_stops).to match_array([])
      end
    end

    it 'handles empty stops' do
      event.stops = ''

      aggregate_failures do
        expect(event.stops).to eq('')
        expect(event.available_stops).to match_array([])
      end
    end

    it 'handles empty spaced stops' do
      event.stops = '  '

      aggregate_failures do
        expect(event.stops).to eq('  ')
        expect(event.available_stops).to match_array([])
      end
    end

    it 'handles single-valued stops' do
      event.stops = 'Bergamo'

      aggregate_failures do
        expect(event.stops).to eq('Bergamo')
        expect(event.available_stops).to match_array(%w[Bergamo])
      end
    end

    it 'handles value + space stops' do
      event.stops = ' Bergamo,  '

      aggregate_failures do
        expect(event.stops).to eq(' Bergamo,  ')
        expect(event.available_stops).to match_array(%w[Bergamo])
      end
    end

    it 'handles multi-value stops' do
      event.stops = ' Bergamo, Altro '

      aggregate_failures do
        expect(event.stops).to eq(' Bergamo, Altro ')
        expect(event.available_stops).to match_array(%w[Bergamo Altro])
      end
    end
  end

  describe '#all_names' do
    it 'handles names as a SQL query' do
      expected = <<~SQL.squish.strip.tr("\n", ' ').gsub(/\s+/, ' ')
        SELECT
           "events"."id",
           "teams"."name" || ' vs ' || "away_teams_events"."name" || ' ' || COALESCE("events"."transport_mean",'') || ' (' || "competitions"."name" || ', ' || "events"."date" || ')'
            AS full_name
        FROM
           "events"
           INNER JOIN
              "competitions"
              ON "competitions"."id" = "events"."competition_id"
           INNER JOIN
              "teams"
              ON "teams"."id" = "events"."home_team_id"
           INNER JOIN
              "teams" "away_teams_events"
              ON "away_teams_events"."id" = "events"."away_team_id"
      SQL
      expect(described_class.all_names.to_sql).to eq(expected)
    end

    it 'returns the expected value' do
      event_a = FactoryBot.create(:event)
      event_b = FactoryBot.create(:event)

      actual = described_class.order(:id).all_names

      aggregate_failures do
        expect(actual.map(&:id)).to match_array([event_a.id, event_b.id])
        expect(actual.map(&:full_name)).to match_array([event_a.to_s, event_b.to_s])
      end
    end
  end
end
