# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Album, type: :model do
  context 'default album' do
    subject { FactoryBot.build :album }

    it { is_expected.to respond_to(:title) }
    it { is_expected.to respond_to(:url) }
    it { is_expected.to respond_to(:event_id) }
  end
end
