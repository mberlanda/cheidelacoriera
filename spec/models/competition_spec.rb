# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition, type: :model do
  context 'default competition' do
    subject { FactoryBot.build :competition }

    it { should respond_to(:name) }
  end

  context 'slug' do
    subject { FactoryBot.create :competition, name: 'name' }

    it 'should be generated from name if blank' do
      expect(subject.slug).to eq 'name'
    end

    it 'should be generated again when name change' do
      expect { subject.update! name: 'another name' }.to change {
        subject.slug
      }.from('name').to('another-name')
    end
  end
end
