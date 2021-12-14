# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MailchimpJob do
  let(:job) { described_class.new }
  let(:user) { FactoryBot.create(:user) }

  before do
    allow(Mailchimp).to receive(:calculate_id).and_return(123_456)
  end

  context 'when response successfull' do
    it 'updates user mailing_listed attribute' do
      expect(user.mailing_listed).to eq(false)

      allow(job.gibbon_request).to receive(:upsert).and_return(true)
      job.perform(user)

      expect(user.mailing_listed).to eq(true)
    end
  end

  context 'when response is an error' do
    it 'does not update user mailing_listed attribute' do
      expect(user.mailing_listed).to eq(false)

      allow(job.gibbon_request).to receive(:upsert).and_raise(Gibbon::MailChimpError)
      job.perform(user)

      expect(user.mailing_listed).to eq(false)
    end
  end
end
