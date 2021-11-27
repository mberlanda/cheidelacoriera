# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Competition, type: :model do
  context 'default competition' do
    subject { FactoryBot.build :competition }

    it { is_expected.to respond_to(:name) }
  end

  context 'slug' do
    subject { FactoryBot.create :competition, name: 'name' }

    it 'is generated from name if blank' do
      expect(subject.slug).to eq 'name'
    end

    it 'is generated again when name change' do
      expect do
        subject.update! name: 'another name'
      end.to change(subject,
                    :slug).from('name').to('another-name')
    end
  end
end
