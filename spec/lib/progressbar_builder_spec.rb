# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProgressbarBuilder do
  it 'builds an item for availability below 25%' do
    event = FactoryBot.build(:event)
    allow(event).to receive(:percentage_availability).and_return(0)

    actual = described_class.build(event)
    expect(actual).to be_a_valid_html
    expect(actual).to include('progress-bar-danger')
  end

  it 'builds an item for availability between 25 and 50%' do
    event = FactoryBot.build(:event)
    allow(event).to receive(:percentage_availability).and_return(30)

    actual = described_class.build(event)
    expect(actual).to be_a_valid_html
    expect(actual).to include('progress-bar-warning')
  end

  it 'builds an item for availability between 50 and 75%' do
    event = FactoryBot.build(:event)
    allow(event).to receive(:percentage_availability).and_return(66)

    actual = described_class.build(event)
    expect(actual).to be_a_valid_html
    expect(actual).to include('progress-bar-info')
  end

  it 'builds an item for availability above 75%' do
    event = FactoryBot.build(:event)
    allow(event).to receive(:percentage_availability).and_return(88)

    actual = described_class.build(event)
    expect(actual).to be_a_valid_html
    expect(actual).to include('progress-bar-success')
  end
end
