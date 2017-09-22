# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition, type: :model do
  context 'default competition' do
    subject { FactoryGirl.create :competition }

    it { should respond_to(:name) }
  end
end
