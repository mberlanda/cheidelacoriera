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

  describe 'validates' do
    it 'name presence' do
      invalid_team = FactoryGirl.build(:team, name: nil)
      expect(invalid_team.valid?).to be(false)
    end

    it 'name not empty' do
      invalid_team = FactoryGirl.build(:team, name: '')
      expect(invalid_team.valid?).to be(false)
    end

    it 'country presence' do
      invalid_team = FactoryGirl.build(:team, country: nil)
      expect(invalid_team.valid?).to be(false)
    end

    it 'country not empty' do
      invalid_team = FactoryGirl.build(:team, country: '')
      expect(invalid_team.valid?).to be(false)
    end

    it 'name and country uniqueness' do
      invalid_team = FactoryGirl.build(
        :team,
        name: team.name,
        country: team.country
      )
      expect(invalid_team.valid?).to be(false)
    end

    it 'nil url allowed' do
      valid_team = FactoryGirl.build(:team, url: nil)
      expect(valid_team.valid?).to be(true)
    end

    it 'http url allowed' do
      valid_team = FactoryGirl.build(:team, url: 'http://www.google.com')
      expect(valid_team.valid?).to be(true)
    end

    it 'https url allowed' do
      valid_team = FactoryGirl.build(:team, url: 'https://www.google.com')
      expect(valid_team.valid?).to be(true)
    end

    it 'invalid url' do
      invalid_team = FactoryGirl.build(:team, url: 'www.google.com')
      expect(invalid_team.valid?).to be(false)
    end
  end
end
