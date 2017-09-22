# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Team, type: :model do
  let!(:team) { FactoryGirl.create :team }

  context 'default team' do
    subject { team }

    it { should respond_to(:name) }
    it { should respond_to(:country) }
    it { should respond_to(:url) }
    it { should respond_to(:image_url) }
    it { should respond_to(:description) }
  end
end
